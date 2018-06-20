require_relative 'spec_helper'

RSpec.describe GLMath::Rect do
  let(:subject) { Rect.new(x: 1, y: 2, width: 3, height: 4) }

  describe '::from_points' do
    let(:p1) { Vector2[4, 2] }
    let(:p2) { Vector2[1, 6] }

    it 'creates a rect from any two points' do
      expect(Rect.from_points(p1, p2)).to eq subject
    end
  end

  describe '::from_center' do
    it 'builds a rect from center and dimensions' do
      expect(Rect.from_center(cx: 2.5, cy: 4.0, width: 3, height: 4)).to eq subject
    end
  end

  describe '::square' do
    example 'creates a square' do
      expect(Rect.square(size: 4)).to eq(Rect.new(width: 4, height: 4))
    end
  end

  describe '#initialize' do

  end

  describe '#[]' do

  end

  describe '#==' do

  end

  describe '#top' do
    it 'should be 2' do
      expect(subject.top).to eq 2
    end
  end

  describe '#bottom' do
    it 'should be 6' do
      expect(subject.bottom).to eq 6
    end
  end

  describe '#left' do
    it 'should be 1' do
      expect(subject.left).to eq 1
    end
  end

  describe '#right' do
    it 'should be 4' do
      expect(subject.right).to eq 4
    end
  end

  describe '#center' do
    it 'should be [3.5, 4]' do
      expect(subject.center).to eq [2.5, 4]
    end
  end

  describe '#center_vector' do
    it 'should be Vector2[3.5, 4]' do
      expect(subject.center_vector).to eq Vector2[2.5, 4]
    end
  end

  describe '#center_x' do
    it 'should be 3.5' do
      expect(subject.center_x).to eq 2.5
    end
  end

  describe '#center_y' do
    it 'should be 4' do
      expect(subject.center_y).to eq 4
    end
  end

  describe '#include?' do
    it 'includes the point [3, 4]' do
      expect(subject.include?(3, 4)).to be true
    end

    it "doesn't include the point [5, 7]" do
      expect(subject.include?(5, 7)).to be false
    end
  end

  describe '#outside?' do
    it 'the point [3, 4] is inside' do
      expect(subject.outside?(3, 4)).to be false
    end

    it 'the point [5, 7] is outside' do
      expect(subject.outside?(5, 7)).to be true
    end
  end

  describe '#to_a' do
    it 'converts the rect to an array' do
      expect(subject.to_a).to eq [1, 2, 3, 4]
    end
  end

  describe '#area' do
    it 'should be 12' do
      expect(subject.area).to eq 12
    end
  end

  describe '#perimeter' do
    it 'should be 14' do
      expect(subject.perimeter).to eq 14
    end
  end

  describe '#to_s' do
    it 'converts into string format' do
      expect(subject.to_s).to eq "<Rect x: 1, y: 2, width: 3, height: 4>"
    end
  end

  # describe '#vertices' do
  #
  # end
end