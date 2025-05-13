# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::EnumVariant
  include Codify::Rust

  attr_reader :name, :type, :summary
  attr_accessor :comment

  def initialize(name, type = nil, &block)
    @name = name.to_sym
    @type = type
    raise ArgumentError, "#{type.inspect}" unless type.nil? || type.is_a?(Type)
    block.call(self) if block_given?
  end

  ##
  # @return [Boolean]
  def comment?
    self.comment && !self.comment.empty?
  end

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
end # Codify::Rust::EnumVariant
