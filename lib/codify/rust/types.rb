# This is free and unencumbered software released into the public domain.

require_relative 'type'

module Codify::Rust::Types
  Named = ::Struct.new('Named', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] } # NB
    type.define_method(:to_s) { t.to_s }
  end

  Val = ::Struct.new('Val', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] }
    type.define_method(:to_s) { t.to_s }
  end

  Bool = Val.new(:bool).freeze
  I64 = Val.new(:i64).freeze
  F64 = Val.new(:f64).freeze
  String = Val.new(:String).freeze

  Ref = ::Struct.new('Ref', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "&#{t}" }
  end

  Unit = ::Struct.new('Unit', :m) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [] }
    type.define_method(:to_s) { m ? "(/*#{m}*/)" : "()" }
  end

  Vec = ::Struct.new('Vec', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "Vec<#{t || '_'}>" }
  end

  Option = ::Struct.new('Option', :t) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t] }
    type.define_method(:to_s) { "Option<#{t}>" }
  end

  Result = ::Struct.new('Result', :t, :e) do |type|
    include Codify::Rust::Type
    type.define_method(:types) { [t, e] }
    type.define_method(:to_s) { "Result<#{t}, #{e}>" }
  end
end # Codify::Rust::Types
