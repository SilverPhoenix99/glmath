require_relative 'spec_helper'

RSpec.describe Vector4 do

  it { Vector4.size.should == 4 }
  it { Vector4.zero.size.should == 4 }

  describe '#initialize' do

    it "doesn't expect more than 4 parameters" do
      expect { Vector4.new(1.0, 2.0, 3.0, 4.0, 5.0) }.to raise_error(ArgumentError)
    end

    it "doesn't expect non Numeric parameters" do
      expect { Vector4.new(1.0, :a) }.to raise_error(ArgumentError)
    end

    it 'expects 4 Numeric parameters' do
      expect { Vector4.new(1.0, 2.0, 3.0, 4.0) }.not_to raise_error
    end

  end

  describe 'zero vector' do

    it 'creates a zero vector' do
      Vector4.zero.should == Vector4[0.0, 0.0, 0.0, 0.0]
    end

  end

  subject { Vector4.new(1.0, 2.0, 3.0, 4.0) }

  describe 'accessor' do

    it { subject.x.should == 1.0 }
    it { subject.x.should == subject[0] }

    it { subject.y.should == 2.0 }
    it { subject.y.should == subject[1] }

    it { subject.z.should == 3.0 }
    it { subject.z.should == subject[2] }

    it { subject.w.should == 4.0 }
    it { subject.w.should == subject[3] }

  end

  describe 'sum' do

    it 'accepts a Vector4' do
      (subject + subject).should == Vector4[2 * subject.x, 2 * subject.y, 2 * subject.z, 2 * subject.w]
    end

    it "doesnt accept something other than a Vector4" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end

  end

  describe 'subtraction' do

    it 'accepts a Vector4' do
      (subject - subject).should == Vector4.zero
    end

    it "doesnt accept something other than a Vector4" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

  describe 'multiplication' do

    it 'accepts a Numeric' do
      (subject * 2).should == Vector4.new(subject.x * 2, subject.y * 2, subject.z * 2, subject.w * 2)
    end

    it 'accepts a Matrix4' do
      (subject * Matrix4[ 1.0,  2.0,  3.0,  4.0,
                          5.0,  6.0,  7.0,  8.0,
                          9.0, 10.0, 11.0, 12.0,
                         13.0, 14.0, 15.0, 16.0]).should == Vector4[90.0, 100.0, 110.0, 120.0]
    end

    it "doesn't accept something other than a Numeric or Matrix4" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

  describe 'division' do

    it 'accepts a Numeric' do
      (subject / 2.0).should == Vector4[subject.x / 2.0, subject.y / 2.0, subject.z / 2.0, subject.w / 2.0]
    end

    it "doesn't accept something other than a Numeric" do
      expect { subject / :a }.to raise_error(ArgumentError)
    end

  end

  describe 'symmetric' do

    it { (-subject).should == Vector4[-subject.x, -subject.y, -subject.z, -subject.w] }

  end

  describe 'inner_product' do

    it 'accepts a Vector4' do
      (subject.dot(subject)).should == 30
    end

    it "doesn't accept anything other than a Vector4" do
      expect { subject.dot :a }.to raise_error(ArgumentError)
    end

  end

  describe 'magnitude' do

    it { subject.magnitude.should == Math.sqrt(30) }

  end

  describe 'angle' do

    it { subject.angle(subject) == 0 }

  end

  describe 'normalize' do

    it { subject.normalize.should == Vector4[subject.x / Math.sqrt(30),
                                             subject.y / Math.sqrt(30),
                                             subject.z / Math.sqrt(30),
                                             subject.w / Math.sqrt(30)] }

  end

end
