# This is free and unencumbered software released into the public domain.

require_relative 'types'

class Codify::Rust::Definition
  include Codify::Rust
  include Type

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
  def comment?
    self.comment && !self.comment.empty?
  end

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
end # Codify::Rust::Definition
