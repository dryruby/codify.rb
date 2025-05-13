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
