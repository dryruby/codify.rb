# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::EnumVariant
  include Codify::Rust

  attr_reader :name, :type, :default, :summary
  attr_accessor :comment

  def initialize(name, type = nil, default: nil, rename: nil, other: nil, &block)
    @name = name.to_sym
    @type = type
    raise ArgumentError, "#{type.inspect}" unless type.nil? || type.is_a?(Type)
    @default = default
    @rename = rename
    @other = other
    block.call(self) if block_given?
  end

  ##
  # @return [Boolean]
  def defaultible?
    self.default
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
    out.puts "    #[default]" if @default
    out.puts "    #[cfg_attr(feature = \"serde\", serde(rename = \"#{@rename}\"))]" if @rename
    out.puts "    #[cfg_attr(feature = \"serde\", serde(other))]" if @other
    if !@type
      out.puts "    #{@name},"
    else
      out.puts "    #{@name}(#{@type}),"
    end
  end
end # Codify::Rust::EnumVariant
