require_relative 'spec_helper'

RSpec.describe Vector2 do

  describe '::size' do
    it 'should be 2' do
      expect(Vector2.size).to equal 2
    end
  end

  describe '::zero' do
    it 'creates a zero vector' do
      expect(Vector2.zero).to eq Vector2[0.0, 0.0]
    end
  end

  describe '::x' do
    it 'creates a x axis unit vector' do
      expect(Vector2.x).to eq(Vector2[1.0, 0.0])
    end
  end

  describe '::y' do
    it 'creates a y axis unit vector' do
      expect(Vector2.y).to eq(Vector2[0.0, 1.0])
    end
  end

  describe '#initialize' do
    it "doesn't expect more than 2 parameters" do
      expect { Vector2.new(1.0, 2.0, 3.0) }.to raise_error(ArgumentError)
    end
  end

  subject { Vector2.new(1.0, 2.0) }

  describe '#accessor' do
    it 'x value should be equal to 1' do
      expect(subject.x).to eq 1.0
      expect(subject.x).to eq subject[0]
    end

    it 'y value should be equal to 2' do
      expect(subject.y).to eq 2.0
      expect(subject.y).to eq subject[1]
    end
  end

  describe '#expand' do
    it 'accepts one Vector2 argument' do
      expect(subject.expand(Vector2[3, 4])).to eq Vector4[1.0, 2.0, 3, 4]
    end

    it 'accepts one Numeric argument' do
      expect(subject.expand(3)).to eq Vector3[1.0, 2.0, 3]
    end

    it 'accepts two Numeric arguments' do
      expect(subject.expand(3, 4)).to eq Vector4[1.0, 2.0, 3, 4]
    end

    it "doesn't accept more than 2 parameters" do
      expect { subject.expand(1, 2, 3)}.to raise_error(ArgumentError)
    end
  end

  describe '#size' do
    it 'should be 2' do
      expect(subject.size).to equal 2
    end
  end

  describe '#multiplication' do
    it 'accepts a Numeric' do
      expect(subject * 2).to eq Vector2[subject.x * 2, subject.y * 2]
    end

    it 'accepts a Matrix2' do
      expect(subject * Matrix2[1.0, 2.0, 3.0, 4.0]).to eq Vector2[7.0, 10.0]
    end

    it "doesn't accept something other than a Numeric or Matrix2" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end
  end
end
