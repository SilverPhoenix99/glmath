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
    let(:v2) { Vector2[3.0, 4.0] }
    let(:v3) { Vector3[3.0, 4.0, 1.5] }
    let(:v4) { Vector4[3.0, 4.0, 1.5, -2.0] }
    let(:m2) { Matrix2.I }
    let(:m3) { Matrix3.I }
    let(:m4) { Matrix4.I }

    it 'only expects Vector or Matrix' do
      expect { scalar * n }.to raise_error(ArgumentError)
    end

    it { (scalar * v2).should eq(n * v2) }
    it { (scalar * v3).should eq(n * v3) }
    it { (scalar * v4).should eq(n * v4) }
    it { (scalar * m2).should eq(n * m2) }
    it { (scalar * m3).should eq(n * m3) }
    it { (scalar * m4).should eq(n * m4) }

  end

  describe 'division' do

    let(:n) { 2 }
    let(:scalar) { Scalar.new(n) }
    let(:m2) { Matrix2[1.0, 2.0, 3.0, 4.0] }
    let(:m3) { Matrix2.translation(1.0, 2.0) }
    let(:m4) { Matrix3.translation(1.0, 2.0, 3.0) }

    it "doesn't expect a Numeric" do
      expect { scalar / n }.to raise_error(ArgumentError)
    end

    it "doesn't expect a Vector" do
      expect { scalar / Vector2[3.0, 4.0] }.to raise_error(ArgumentError)
    end

    it { (scalar / m2).should eq(n * m2.inverse) }
    it { (scalar / m3).should eq(n * m3.inverse) }
    it { (scalar / m4).should eq(n * m4.inverse) }

  end
end