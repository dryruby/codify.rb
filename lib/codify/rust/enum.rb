# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::Enum < Codify::Rust::Definition
  attr_reader :variants

  ##
  # @param [String, #to_s] name
  # @param [Array<EnumVariant>, #to_a] variants
  # @param [Array<Symbol, #to_sym>, #to_a] derives
  # @param [String, #to_s] comment
  # @param [Proc] block
  def initialize(name, variants: nil, rename_all: nil, **kwargs, &block)
    super(name, **kwargs)
    @variants = (variants || []).to_a.dup
    @rename_all = rename_all&.to_s
    block.call(self) if block_given?
  end

  ##
  # @return [Array<Type>]
  def types
    @variants.map(&:type).compact.uniq.to_a
  end

  ##
  # @return [Boolean]
  def has_default?()
    @variants.any?(&:default)
  end

  ##
  # @param [IO] out
  # @return [void]
  def write(out)
    super(out, extra_derives: self.has_default? ? %i(Default) : [])
    if self.variants.empty?
      out.puts "pub struct #{@name};"
    else
      if @cfg_derives.include?(:serde)
        if @rename_all
          out.puts "#[cfg_attr(feature = \"serde\", serde(untagged, rename_all = \"lowercase\"))]"
        else
          out.puts "#[cfg_attr(feature = \"serde\", serde(untagged))]"
        end
      end
      out.puts "pub enum #{@name} {"
      @variants.each_with_index do |variant, i|
        out.puts if i > 0
        out.puts wrap_text(variant.comment, 80-8).map { |s| s.prepend("    /// ") }.join("\n") if variant.comment?
        variant.write(out)
      end
      out.puts "}"
    end
  end
end # Codify::Rust::Enum
