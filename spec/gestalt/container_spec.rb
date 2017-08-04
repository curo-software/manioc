require 'spec_helper'

use 'container'

RSpec.describe Gestalt::Container do
  let(:container) {
    Gestalt::Container.new do
      error { raise 'nope'}
      count { rand 1 .. 1_000 }
      now   { Time.now }
      a     { 1 }
      b     { a * 2 }
      c     { b * 3 }
    end
  }

  it 'constructs lazily' do
    expect { container.error }.to raise_error 'nope'
  end

  it 'caches values' do
    expect(container.count).to eq container.count
  end

  it 'can reset individual values' do
    old = container.now
    container.reset :now
    expect(container.now).to be > old
  end

  it 'can reset all values' do
    old = container.now
    container.reset
    expect(container.now).to be > old
  end

  it 'can override values' do
    overridden = container.with do
      b { a * 10}
    end

    expect(container.c ).to eq 6
    expect(overridden.c).to eq 30

    expect(container.b ).to eq 2
    expect(overridden.b).to eq 10
  end
end
