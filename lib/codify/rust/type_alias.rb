# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::TypeAlias < Codify::Rust::Definition
  ##
  # @param [String, #to_s] name
  # @param [Type] type
  # @param [String, #to_s] comment
  # @param [Proc] block
  def initialize(name, type, **kwargs, &block)
    super(name, **kwargs, derives: [], cfg_derives: [])
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
    out.puts "pub type #{@name} = #{@type};"
  end
end # Codify::Rust::TypeAlias
