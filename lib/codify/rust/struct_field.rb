# This is free and unencumbered software released into the public domain.

require_relative 'definition'

class Codify::Rust::StructField
  include Codify::Rust

  attr_reader :name, :type, :summary
  attr_accessor :comment, :rename

  def initialize(name, type, &block)
    @name = name.to_s.gsub('[]', '').gsub('.', '_')
    @type = type
    raise ArgumentError, "#{type.inspect}" unless type.is_a?(Type)
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
end # Codify::Rust::StructField
