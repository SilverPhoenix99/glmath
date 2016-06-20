require_relative 'spec_helper'

RSpec.describe Vector3 do

  it { Vector3.size.should == 3 }
  it { Vector3.zero.size.should == 3 }

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

  describe 'zero vector' do

    it 'creates a zero vector' do
      Vector2.zero.should == Vector2[0.0, 0.0]
    end

  end

  subject { Vector3.new(1.0, 2.0, 3.0) }

  describe 'accessor' do

    it { subject.x.should == 1.0 }
    it { subject.x.should == subject[0] }

    it { subject.y.should == 2.0 }
    it { subject.y.should == subject[1] }

    it { subject.z.should == 3.0 }
    it { subject.z.should == subject[2] }

  end

  describe 'sum' do

    it 'accepts a Vector3' do
      (subject + Vector3[3.0, 2.0, 1.0]).should == Vector3[4.0, 4.0, 4.0]
    end

    it "doesnt accept something other than a Vector3" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end

  end

  describe 'subtraction' do

    it 'accepts a Vector3' do
      (subject - subject).should == Vector3.zero
    end

    it "doesnt accept something other than a Vector3" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

  describe 'multiplication' do

    it 'accepts a Numeric' do
      (subject * 2).should == Vector3.new(subject.x * 2, subject.y * 2, subject.z * 2)
    end

    it 'accepts a Matrix3' do
      (subject * Matrix3[1, 2, 3, 4, 5, 6, 7, 8, 9]).should == Vector3.new(30.0, 36.0, 42.0)
    end

    it "doesn't accept anything other than a Numeric or Matrix3" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

  describe 'division' do

    it 'accepts a Numeric' do
      (subject / 2.0).should == Vector3[subject.x / 2.0, subject.y / 2.0, subject.z / 2.0]
    end

    it "doesn't accept something other than a Numeric" do
      expect { subject / :a }.to raise_error(ArgumentError)
    end

  end

  describe 'symmetric' do

    it { (-subject).should == Vector3[-subject.x, -subject.y, -subject.z] }

  end

  describe 'inner_product' do

    it 'accepts a Vector2' do
      (subject.dot(subject)).should == 14
    end

    it "doesn't accept anything other than a Vector2" do
      expect { subject.dot :a }.to raise_error(ArgumentError)
    end

  end

  describe 'magnitude' do

    it { subject.magnitude.should == Math.sqrt(14) }

  end

  describe 'angle' do

    it { subject.angle(subject) == 0 }

  end

  describe 'normalize' do

    it { subject.normalize.should == Vector3[subject.x / Math.sqrt(14), subject.y / Math.sqrt(14), subject.z / Math.sqrt(14)] }

  end

  describe 'expansion' do

    it 'accepts a Numeric' do
      (subject.expand(4)).should == Vector4.new(1.0, 2.0, 3.0, 4)
    end

    it "doesn't accept anything other than a Numeric" do
      expect { (subject.expand(:a)) }.to raise_error(ArgumentError)
    end

  end

  describe 'outer_product' do

    describe 'with itself' do
      it 'is a zero vector' do
        (subject.cross(subject)).should == Vector3.zero
      end
    end

    describe 'with symmetric' do
      it 'gives a zero vector' do
        (subject.cross(-subject)).should == Vector3.zero
      end
    end

    describe 'X axis with Z axis' do
      it 'gives Y axis' do
        expect(Vector3.X.cross(Vector3.Z)).to eq(Vector3.Y)
      end
    end

    describe 'Z axis with X axis' do
      it 'gives negative Y axis' do
        expect(Vector3.Z.cross(Vector3.X)).to eq(-Vector3.Y)
      end
    end

  end

end