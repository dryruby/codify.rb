# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust
RustStruct = Codify::Rust::Struct # to not break RSpec

RSpec.describe RustStruct do
  describe '.new' do
    it 'constructs the type' do
      RustStruct.new(:MyStruct)
    end
  end

  describe '#to_s' do
    it 'returns the Rust typename' do
      expect(RustStruct.new(:MyStruct).to_s).to eq('MyStruct')
    end
  end

  describe '#to_rust_code' do
    it 'generates Rust code' do
      expect(RustStruct.new(:MyStruct).to_rust_code).to eq(<<~EOF)
        #[derive(Debug)]
        pub struct MyStruct;
      EOF
    end
  end
end
