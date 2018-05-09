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
    let(:m2) { Matrix2::I }
    let(:m3) { Matrix3::I }
    let(:m4) { Matrix4::I }

    it 'only expects Vector or Matrix' do
      expect { scalar * n }.to raise_error(ArgumentError)
    end

    it 'should multiply by a Vector2' do
      expect(scalar * v2).to eq(n * v2)
    end

    it 'should multiply by a Vector3'do
      expect(scalar * v3).to eq(n * v3)
    end

    it 'should multiply by a Vector3' do
      expect(scalar * v4).to eq(n * v4)
    end

    it 'should multiply by a Matrix2' do
      expect(scalar * m2).to eq(n * m2)
    end

    it 'should multiply by a Matrix3' do
      expect(scalar * m3).to eq(n * m3)
    end

    it 'should multiply by a Matrix4' do
      expect(scalar * m4).to eq(n * m4)
    end
  end

  describe 'division' do

    let(:n) { 2 }
    let(:scalar) { Scalar.new(n) }
    let(:m2) { Matrix2[1.0, 2.0, 3.0, 4.0] }
    let(:m3) { Matrix3.translation(1.0, 2.0) }
    let(:m4) { Matrix4.translation(1.0, 2.0, 3.0) }

    it "doesn't expect a Numeric" do
      expect { scalar / n }.to raise_error(ArgumentError)
    end

    it "doesn't expect a Vector" do
      expect { scalar / Vector2[3.0, 4.0] }.to raise_error(ArgumentError)
    end

    it  'should divide by a Matrix2' do
      expect(scalar / m2).to eq(n * m2.inverse)
    end

    it 'should divide by a Matrix2' do
      expect(scalar / m3).to eq(n * m3.inverse)
    end

    it 'should divide by a Matrix2' do
      expect(scalar / m4).to eq(n * m4.inverse)
    end

  end

  describe '#==' do
    let(:n) { 2 }
    let(:scalar) { Scalar.new(2) }

    it 'should be equal to 2' do
      expect(scalar == 2).to be true
    end

    it "shouldn't be equal to anything than 2 or Scalar.new(2)" do
      expect(scalar == 'abc').to be false
    end
  end
end