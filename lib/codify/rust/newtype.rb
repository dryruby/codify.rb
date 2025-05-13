# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::Newtype < Codify::Rust::Definition
  ##
  # @param [String, #to_s] name
  # @param [Type] type
  # @param [Array<Symbol, #to_sym>, #to_a] derives
  # @param [String, #to_s] comment
  # @param [Proc] block
  def initialize(name, type, **kwargs, &block)
    super(name, **kwargs)
    raise ArgumentError, "#{type.inspect}" unless type.is_a?(Type)
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
end # Codify::Rust::Newtype
