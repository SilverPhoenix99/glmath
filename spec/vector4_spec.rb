require_relative 'spec_helper'

RSpec.describe Vector4 do

  describe '::size' do
    it 'should be 4' do
      expect(Vector4.size).to equal 4
    end
  end

  describe '#initialize' do
    it "doesn't expect more than 4 parameters" do
      expect { Vector4.new(1.0, 2.0, 3.0, 4.0, 5.0) }.to raise_error(ArgumentError)
    end
  end

  describe '::zero' do
    it 'creates a zero vector' do
      expect(Vector3.zero).to eq(Vector3[0.0, 0.0, 0.0])
    end
  end

  subject { Vector4.new(1.0, 2.0, 3.0, 4.0) }

  describe '#accessor' do
    it 'x value should be equal to 1' do
      expect(subject.x).to eq 1.0
      expect(subject.x).to eq subject[0]
    end

    it 'y value should be equal to 2' do
      expect(subject.y).to eq 2.0
      expect(subject.y).to eq subject[1]
    end

    it 'z value should be equal to 3' do
      expect(subject.z).to eq 3.0
      expect(subject.z).to eq subject[2]
    end

    it 'w value should be equal to 4' do
      expect(subject.w).to eq 4.0
      expect(subject.w).to eq subject[3]
    end
  end

  describe '#multiplication' do
    it 'accepts a Numeric' do
      expect(subject * 2).to eq Vector4[subject.x * 2, subject.y * 2, subject.z * 2, subject.w * 2]
    end

    it 'accepts a Matrix4' do
      expect(subject * Matrix4[ 1.0,  2.0,  3.0,  4.0,
                                5.0,  6.0,  7.0,  8.0,
                                9.0, 10.0, 11.0, 12.0,
                               13.0, 14.0, 15.0, 16.0]).to eq Vector4[90.0, 100.0, 110.0, 120.0]
    end

    it "doesn't accept something other than a Numeric or Matrix4" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end
  end
end
