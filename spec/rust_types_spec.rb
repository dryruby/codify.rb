# This is free and unencumbered software released into the public domain.

require 'codify/rust'

include Codify::Rust

RSpec.describe Types::Bool do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Bool.to_s).to eq('bool')
    end
  end
end

RSpec.describe Types::I64 do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::I64.to_s).to eq('i64')
    end
  end
end

RSpec.describe Types::F64 do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::F64.to_s).to eq('f64')
    end
  end
end

RSpec.describe Types::String do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::String.to_s).to eq('String')
    end
  end
end

RSpec.describe Types::Ref do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Ref.new(Types::String).to_s).to eq('&String')
    end
  end
end

RSpec.describe Types::Unit do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Unit.new.to_s).to eq('()')
      expect(Types::Unit.new('Comment').to_s).to eq('(/*Comment*/)')
    end
  end
end

RSpec.describe Types::Vec do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Vec.new.to_s).to eq('Vec<_>')
      expect(Types::Vec.new(Types::String).to_s).to eq('Vec<String>')
    end
  end
end

RSpec.describe Types::Option do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Option.new(Types::String).to_s).to eq('Option<String>')
    end
  end
end

RSpec.describe Types::Result do
  describe '#to_s' do
    it 'returns Rust code' do
      expect(Types::Result.new(Types::Unit.new, Types::String).to_s).to eq('Result<(), String>')
    end
  end
end
