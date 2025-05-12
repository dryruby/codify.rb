# This is free and unencumbered software released into the public domain.

require 'codify/rust'

RSpec.describe Codify::Rust::Types do
end

RSpec.describe Codify::Rust::Types::Bool do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Codify::Rust::Types::Bool.to_s).to eq('bool')
    end
  end
end

RSpec.describe Codify::Rust::Types::I64 do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Codify::Rust::Types::I64.to_s).to eq('i64')
    end
  end
end

RSpec.describe Codify::Rust::Types::F64 do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Codify::Rust::Types::F64.to_s).to eq('f64')
    end
  end
end

RSpec.describe Codify::Rust::Types::String do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Codify::Rust::Types::String.to_s).to eq('String')
    end
  end
end
