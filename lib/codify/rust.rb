# This is free and unencumbered software released into the public domain.

module Codify; end
module Codify::Rust; end

module Codify::Rust::Type
  def definition?
    Codify::Rust::Definition === self
  end

  ##
  # @return [Boolean]
  def primitive?() true end

  ##
  # @return [Array<Type>]
  def types() [] end

  ##
  # @return [void]
  def each_subtype(&block)
    self.types.each do |subtype|
      raise RuntimeError, subtype.inspect unless subtype.is_a?(Codify::Rust::Type)
      block.call(subtype) if block_given?
      subtype.each_subtype(&block)
    end
  end
end # Codify::Rust::Type

module Codify::Rust::Types
  Named = ::Struct.new('Named', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] } # NB
    type.define_method(:to_s) { t.to_s }
  end

  Val = ::Struct.new('Val', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] }
    type.define_method(:to_s) { t.to_s }
  end

  Bool = Val.new(:bool).freeze
  I64 = Val.new(:i64).freeze
  F64 = Val.new(:f64).freeze
  String = Val.new(:String).freeze

  Ref = ::Struct.new('Ref', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "&#{t}" }
  end

  Unit = ::Struct.new('Unit', :m) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] }
    type.define_method(:to_s) { m ? "(/*#{m}*/)" : "()" }
  end

  Vec = ::Struct.new('Vec', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "Vec<#{t}>" }
  end

  Option = ::Struct.new('Option', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "Option<#{t}>" }
  end

  Result = ::Struct.new('Result', :t, :e) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t, e] }
    type.define_method(:to_s) { "Result<#{t}, #{e}>" }
  end
end # Codify::Rust::Types

module Codify::Rust
  class Definition
    include Codify::Rust::Type

    attr_reader :name
    attr_reader :derives
    attr_accessor :comment

    ##
    # @param [String, #to_s] name
    # @param [Array<Symbol, #to_sym>, #to_a] derives
    # @param [String, #to_s] comment
    def initialize(name, derives: nil, comment: nil)
      @name = name.to_s
      @derives = (derives || []).to_a.dup.uniq.map!(&:to_sym).sort
      @comment = comment ? comment.to_s.strip : nil
    end

    ##
    # @return [Boolean]
    def comment?() self.comment && !self.comment.empty? end

    ##
    # @return [Array<Type>]
    def types() [] end

    ##
    # @return [Boolean]
    def primitive?() false end

    ##
    # @return [String]
    def to_s() @name end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      out.puts wrap_text(self.comment, 80-4).map { |s| s.prepend("/// ") }.join("\n") if self.comment?
      out.puts "#[derive(#{@derives.sort.join(", ")})]" unless @derives.empty?
      out.puts "#[cfg_attr(feature = \"serde\", derive(serde::Serialize, serde::Deserialize))]"
    end
  end # Definition

  class Newtype < Definition
    ##
    # @param [String, #to_s] name
    # @param [Type] type
    # @param [Array<Symbol, #to_sym>, #to_a] derives
    # @param [String, #to_s] comment
    # @param [Proc] block
    def initialize(name, type, derives: %i(Clone Debug), comment: nil, &block)
      super(name, derives:, comment:)
      raise ArgumentError, "#{type.inspect}" unless type.is_a?(Rust::Type)
      @type = type
      block.call(self) if block_given?
    end

    ##
    # @return [Array<Type>]
    def types() [@type] end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      super(out)
      out.puts "pub struct #{@name}(pub #{@type});"
    end
  end # Struct

  class Struct < Definition
    attr_reader :fields

    ##
    # @param [String, #to_s] name
    # @param [Array<Field>, #to_a] fields
    # @param [Array<Symbol, #to_sym>, #to_a] derives
    # @param [String, #to_s] comment
    # @param [Proc] block
    def initialize(name, fields: nil, derives: nil, comment: nil, &block)
      super(name, derives:, comment:)
      @fields = (fields || []).to_a.dup
      block.call(self) if block_given?
    end

    ##
    # @return [Array<Type>]
    def types() @fields.map(&:type).uniq.to_a end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      super(out)
      if self.fields.empty?
        out.puts "pub struct #{@name};"
      else
        out.puts "pub struct #{@name} {"
        @fields.each_with_index do |field, i|
          out.puts if i > 0
          out.puts wrap_text(field.comment, 80-8).map { |s| s.prepend("    /// ") }.join("\n") if field.comment?
          out.puts "    #[cfg_attr(feature = \"serde\", serde(rename = \"#{k.id}\"))]" if false
          field.write(out)
        end
        out.puts "}"
      end
    end
  end # Struct

  class Enum < Definition
    attr_reader :variants

    ##
    # @param [String, #to_s] name
    # @param [Array<Variant>, #to_a] variants
    # @param [Array<Symbol, #to_sym>, #to_a] derives
    # @param [String, #to_s] comment
    # @param [Proc] block
    def initialize(name, variants: nil, derives: nil, comment: nil, &block)
      super(name, derives:, comment:)
      @variants = (variants || []).to_a.dup
      block.call(self) if block_given?
    end

    ##
    # @return [Array<Type>]
    def types() @variants.map(&:type).compact.uniq.to_a end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      super(out)
      if self.variants.empty?
        out.puts "pub struct #{@name};"
      else
        out.puts "pub enum #{@name} {"
        @variants.each_with_index do |variant, i|
          out.puts if i > 0
          out.puts wrap_text(variant.comment, 80-8).map { |s| s.prepend("    /// ") }.join("\n") if variant.comment?
          variant.write(out)
        end
        out.puts "}"
      end
    end
  end # Enum

  class Field
    attr_reader :name, :type, :summary
    attr_accessor :comment, :rename

    def initialize(name, type, &block)
      @name = name.to_s.gsub('[]', '').gsub('.', '_')
      @type = type
      raise ArgumentError, "#{type.inspect}" unless type.is_a?(Rust::Type)
      block.call(self) if block_given?
    end

    ##
    # @return [Boolean]
    def comment?() self.comment && !self.comment.empty? end

    ##
    # @return [Array<Type>]
    def types() [@type] end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      out.puts "    #[cfg_attr(feature = \"serde\", serde(rename = \"#{self.rename}\"))]" if self.rename
      out.puts "    pub r##{@name}: #{@type},"
    end
  end # Field

  class Variant
    attr_reader :name, :type, :summary
    attr_accessor :comment

    def initialize(name, type = nil, &block)
      @name = name.to_sym
      @type = type
      raise ArgumentError, "#{type.inspect}" unless type.nil? || type.is_a?(Rust::Type)
      block.call(self) if block_given?
    end

    ##
    # @return [Boolean]
    def comment?() self.comment && !self.comment.empty? end

    ##
    # @return [Array<Type>]
    def types() [@type].compact end

    ##
    # @param [IO] out
    # @return [void]
    def write(out)
      if !@type
        out.puts "    #{@name},"
      else
        out.puts "    #{@name}(#{@type}),"
      end
    end
  end # Variant
end # Codify::Rust
