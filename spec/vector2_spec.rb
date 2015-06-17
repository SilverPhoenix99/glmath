require_relative 'spec_helper'

RSpec.describe Vector2 do

  it { Vector2.size.should == 2 }

  describe '#initialize' do

    it "doesn't expect more than 2 parameters" do
      expect { Vector2.new(1.0, 2.0, 3.0) }.to raise_error(ArgumentError)
    end

    it "doesn't expect non Numeric parameters" do
      expect { Vector2.new(1.0, :a) }.to raise_error(ArgumentError)
    end

    it 'expects 2 Numeric parameters' do
      expect { Vector2.new(1.0, 2.0) }.not_to raise_error
    end

  end

  subject { Vector2.new(1.0, 2.0) }

  describe 'accessor' do

    it { subject.x.should == 1.0 }
    it { subject.x.should == subject[0] }

    it { subject.y.should == 2.0 }
    it { subject.y.should == subject[1] }

  end

  describe 'multiplication' do

    it 'accepts a Numeric' do
      (subject * 2).should == Vector2.new(subject.x * 2, subject.y * 2)
    end

    it 'accepts a Matrix2' do
      (subject * Matrix2[1.0, 2.0, 3.0, 4.0]).should == Vector2[7.0, 10.0]
    end

    it "doesn't accept something other than a Numeric or Matrix2" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

  describe '#expand' do

    it 'accepts one Vector2 argument' do
      subject.expand(Vector2[3, 4]).should == Vector4[1.0, 2.0, 3, 4]
    end

    it 'accepts one Numeric argument' do
      subject.expand(3).should == Vector3[1.0, 2.0, 3]
    end

    it 'accepts two Numeric arguments' do
      subject.expand(3, 4).should == Vector4[1.0, 2.0, 3, 4]
    end

    it "doesn't accept more than 2 parameters" do
      expect { subject.expand(1, 2, 3).to raise_error(ArgumentError) }
    end

  end

end
