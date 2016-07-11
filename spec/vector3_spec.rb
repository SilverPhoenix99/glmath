require_relative 'spec_helper'

RSpec.describe Vector3 do

  describe '::size' do
    it 'should be 3' do
      expect(Vector3.size).to equal 3
    end
  end

  describe '#initialize' do
    it "doesn't expect more than 3 parameters" do
      expect { Vector3.new(1, 2, 3, 4) }.to raise_error(ArgumentError)
    end

    it "doesn't expect non Numeric parameters" do
      expect { Vector3.new(1, :a, 3) }.to raise_error(ArgumentError)
    end

    it 'expects 3 Numeric parameters' do
      expect { Vector3.new(1.0, 2.0, 3) }.not_to raise_error
    end
  end

  describe '::zero' do
    it 'creates a zero vector' do
      expect(Vector3.zero).to eq(Vector3[0.0, 0.0, 0.0])
    end
  end

  describe '::x' do
    it 'creates a x axis unit vector' do
      expect(Vector3.x).to eq(Vector3[1.0, 0.0, 0.0])
    end
  end

  describe '::y' do
    it 'creates a y axis unit vector' do
      expect(Vector3.y).to eq(Vector3[0.0, 1.0, 0.0])
    end
  end

  describe '::z' do
    it 'creates a z axis unit vector' do
      expect(Vector3.z).to eq(Vector3[0.0, 0.0, 1.0])
    end
  end

  subject { Vector3.new(1.0, 2.0, 3.0) }

  describe '#size' do
    it 'should be 3' do
      expect(subject.size).to equal 3
    end
  end

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
  end

  describe '#xy' do
    it 'should be equal to Vector2[1.0, 2.0]' do
      expect(subject.xy).to eq Vector2[1.0, 2.0]
    end
  end

  describe '#xz' do
    it 'should be equal to Vector2[1.0, 3.0]' do
      expect(subject.xz).to eq Vector2[1.0, 3.0]
    end
  end

  describe '#yz' do
    it 'should be equal to Vector2[2.0, 3.0]' do
      expect(subject.yz).to eq Vector2[2.0, 3.0]
    end
  end

  describe 'sum' do
    it 'accepts a Vector3' do
      expect(subject + Vector3[3.0, 2.0, 1.0]).to eq Vector3[4.0, 4.0, 4.0]
    end

    it "doesn't accept something other than a Vector3" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end

  end

  describe '#subtraction' do
    it 'accepts a Vector3' do
      expect(subject - subject).to eq Vector3.zero
    end

    it "doesn't accept something other than a Vector3" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end
  end

  describe '#multiplication' do
    it 'accepts a Numeric' do
      expect(subject * 2).to eq Vector3.new(subject.x * 2, subject.y * 2, subject.z * 2)
    end

    it 'accepts a Matrix3' do
      expect(subject * Matrix3[1, 2, 3, 4, 5, 6, 7, 8, 9]).to eq Vector3.new(30.0, 36.0, 42.0)
    end

    it "doesn't accept anything other than a Numeric or Matrix3" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end
  end

  describe '#division' do
    it 'accepts a Numeric' do
      expect(subject / 2.0).to eq Vector3[subject.x / 2.0, subject.y / 2.0, subject.z / 2.0]
    end

    it "doesn't accept something other than a Numeric" do
      expect { subject / :a }.to raise_error(ArgumentError)
    end
  end

  describe '#symmetric' do
    it 'should have symetric x, y and z values' do
      expect(-subject).to eq Vector3[-subject.x, -subject.y, -subject.z]
    end
  end

  describe '#inner_product' do
    it 'accepts a Vector3' do
      expect(subject.dot(subject)).to eq 14
    end

    it "doesn't accept anything other than a Vector3" do
      expect { subject.dot :a }.to raise_error(ArgumentError)
    end
  end

  describe '#magnitude' do
    it 'should be equal to sqrt(14)' do
      expect(subject.magnitude).to eq Math.sqrt(14)
    end
  end

  describe '#angle' do
    it 'should have a 0 degree angle with itself' do
      expect(subject.angle(subject)).to eq 0
    end

    it 'X and Y should have a 90 degree angle' do
      expect(Vector3.x.angle(Vector3.y)).to eq (Math::PI / 2)
    end
  end

  describe '#normalize' do
    it 'should return a normalized vector' do
      normalized = subject.normalize
      expect(normalized).to eq Vector3[subject.x / Math.sqrt(14),
                                              subject.y / Math.sqrt(14),
                                              subject.z / Math.sqrt(14)]
      expect(normalized.magnitude).to eq 1.0
    end
  end

  describe '#expand' do
    it 'accepts a Numeric' do
      expect(subject.expand(4)).to eq(Vector4.new(1.0, 2.0, 3.0, 4))
    end

    it "doesn't accept anything other than a Numeric" do
      expect { (subject.expand(:a)) }.to raise_error(ArgumentError)
    end
  end

  describe '#outer_product' do
    describe 'with itself' do
      it 'gives a zero vector' do
        expect(subject.cross(subject)).to eq(Vector3.zero)
      end
    end

    describe 'with symmetric' do
      it 'gives a zero vector' do
        expect(subject.cross(-subject)).to eq(Vector3.zero)
      end
    end

    describe ': Z cross X' do
      it 'gives Y' do
        expect(Vector3::Z.cross(Vector3::X)).to eq(Vector3::Y)
      end
    end

    describe ': X cross Z' do
      it 'gives -Y' do
        expect(Vector3::X.cross(Vector3::Z)).to eq(-Vector3::Y)
      end
    end
  end
end