# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Newtype do
  describe '.new' do
    it 'constructs the type' do
      Newtype.new(:MyNewtype, Types::Unit)
    end
  end
end
