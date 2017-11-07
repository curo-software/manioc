require 'spec_helper'

use 'struct'

RSpec.describe Manioc::Struct do
  context 'basic structs' do
    class Basic < Manioc[:foo]
    end

    it 'creates frozen structs by default' do
      b = Basic.new foo: 1
      expect(b.foo).to eq 1
      expect(b).to be_frozen
    end

    it 'can check equality' do
      a1 = Basic.new foo: :a
      a2 = Basic.new foo: :a
      b  = Basic.new foo: :b
      expect(a1).to eq a2
      expect(a2).not_to eq b
    end

    it 'requires fields on initialization' do
      expect { Basic.new }.to raise_error(KeyError, /foo/)
    end

    it 'validates fields on initialization' do
      expect { Basic.new foo: 1, bar: 2 }.to raise_error(KeyError, /bar/)
    end

    it 'updates by copying' do
      a = Basic.new foo: :a
      b = a.with foo: :b
      expect(b.foo).to eq :b
      expect(a.foo).to eq :a
    end
  end

  context 'with defaults' do
    class Defaults < Manioc[:foo, bar: 2]
    end

    it 'can create structs with defaults' do
      d = Defaults.new foo: 1
      expect(d.foo).to eq 1
      expect(d.bar).to eq 2
    end
  end

  context 'mutability' do
    let(:klass) { Manioc.mutable(:a, b: 2) }

    it 'creates mutable objects' do
      object = klass.new a: 1
      expect(object.a).to eq 1
      expect(object.b).to eq 2

      object.b = 5
      expect(object.b).to eq 5
    end
  end
end
