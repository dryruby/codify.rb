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

  describe '#to_rust_code w/o variants' do
    it 'generates Rust code' do
      expect(Enum.new(:MyEnum).to_rust_code).to eq(<<~EOF)
        #[derive(Debug)]
        pub struct MyEnum;
      EOF
    end
  end

  describe '#to_rust_code w/ one variant' do
    it 'generates Rust code' do
      enum = Enum.new(:MyEnum)
      enum.variants << EnumVariant.new(:Null)
      expect(enum.to_rust_code).to eq(<<~EOF)
        #[derive(Debug)]
        pub enum MyEnum {
            Null,
        }
      EOF
    end
  end

  describe '#to_rust_code w/ one default variant' do
    it 'generates Rust code' do
      enum = Enum.new(:MyEnum)
      enum.variants << EnumVariant.new(:Null, default: true)
      expect(enum.to_rust_code).to eq(<<~EOF)
        #[derive(Debug, Default)]
        pub enum MyEnum {
            #[default]
            Null,
        }
      EOF
    end
  end
end
