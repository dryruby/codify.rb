# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Newtype do
  describe '.new' do
    it 'constructs the type' do
      Newtype.new(:MyNewtype, Types::Unit)
    end
  end

  describe '#to_s' do
    it 'returns the Rust typename' do
      expect(Newtype.new(:MyNewtype, Types::Unit).to_s).to eq('MyNewtype')
    end
  end

  describe '#to_rust_code' do
    it 'generates Rust code' do
      expect(Newtype.new(:MyNewtype, Types::Unit).to_rust_code).to eq(<<~EOF)
        #[derive(Debug)]
        pub struct MyNewtype(pub ());
      EOF
    end
  end
end
