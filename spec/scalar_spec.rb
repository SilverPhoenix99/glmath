require_relative 'spec_helper'

RSpec.describe Scalar do

  it 'expects a Numeric' do
    expect { Scalar.new(1) }.not_to raise_error
  end

  it "doesn't expect something other than a Numeric" do
    expect { Scalar.new(:'1') }.to raise_error(ArgumentError)
  end

  describe 'multiplication' do

    let(:n) { 2 }
    let(:scalar) { Scalar.new(n) }
    let(:v) { Vector2[3.0, 4.0] }

    it 'only expects Vector or Matrix' do
      expect { scalar * n }.to raise_error(ArgumentError)
    end

    it { (scalar * v).should eq(n * v) }

    

  end
end