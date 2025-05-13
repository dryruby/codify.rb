# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Enum do
  describe '.new' do
    it 'constructs the type' do
      Enum.new(:MyEnum)
    end
  end

  describe '#to_s' do
    it 'returns the Rust typename' do
      expect(Enum.new(:MyEnum).to_s).to eq('MyEnum')
    end
  end

  describe '#to_rust_code' do
    it 'generates Rust code' do
      expect(Enum.new(:MyEnum).to_rust_code).to eq(<<~EOF)
        #[derive(Debug)]
        pub struct MyEnum;
      EOF
    end
  end
end
