# This is free and unencumbered software released into the public domain.

require_relative 'type'

module Codify::Rust::Types
  Named = ::Struct.new('Named', :t) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Named' end

    def types() [] end # NB
    def to_s() t.to_s end
  end

  Val = ::Struct.new('Val', :t) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Val' end

    def types() [] end
    def to_s() t.to_s end
    def inspect() t.to_s end
  end

  Bool = Val.new(:bool).freeze
  I64 = Val.new(:i64).freeze
  F64 = Val.new(:f64).freeze
  String = Val.new(:String).freeze

  Ref = ::Struct.new('Ref', :t) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Ref' end

    def types() [t] end
    def to_s() "&#{t}" end
  end

  Tuple0 = ::Struct.new('Unit', :m) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Unit' end

    def types() [] end
    def to_s() m ? "(/*#{m}*/)" : '()' end
  end

  Unit = Tuple0.new.freeze

  Vec = ::Struct.new('Vec', :t) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Vec' end

    def types() [t] end
    def to_s() "Vec<#{t || '_'}>" end
  end

  Option = ::Struct.new('Option', :t) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Option' end

    def types() [t] end
    def to_s() "Option<#{t}>" end

    def flatten
      t.is_a?(self.class) ? t : self
    end
  end

  Result = ::Struct.new('Result', :t, :e) do
    include Codify::Rust::Type

    def self.to_s() 'Codify::Rust::Types::Result' end

    def types() [t, e] end
    def to_s() "Result<#{t}, #{e}>" end
  end
end # Codify::Rust::Types
