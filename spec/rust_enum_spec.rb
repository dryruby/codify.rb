# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Enum do
  describe '.new' do
    it 'constructs the type' do
      Enum.new(:MyEnum)
    end
  end
end
