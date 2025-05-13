# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Struct do
  describe '.new' do
    it 'constructs the type' do
      Struct.new(:MyStruct)
    end
  end
end
