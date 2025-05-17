# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::Struct < Codify::Rust::Definition
  attr_reader :fields

  ##
  # @param [String, #to_s] name
  # @param [Array<StructField>, #to_a] fields
  # @param [Array<Symbol, #to_sym>, #to_a] derives
  # @param [String, #to_s] comment
  # @param [Proc] block
  def initialize(name, fields: nil, **kwargs, &block)
    super(name, **kwargs)
    @fields = (fields || []).to_a.dup
    block.call(self) if block_given?
  end

  ##
  # @return [Boolean]
  def defaultible?
    @fields.all?(&:defaultible?)
  end

  ##
  # @return [Array<Type>]
  def types
    @fields.map(&:type).uniq.to_a
  end

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
end # Codify::Rust::Struct
