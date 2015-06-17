require_relative 'spec_helper'

RSpec.describe Vector3 do

  it { Vector3.size.should == 3 }

  describe '#initialize' do

    it "doesn't expect more than 3 parameters" do
      expect { Vector3.new(1, 2, 3, 4) }.to raise_error(ArgumentError)
    end

    it "doesn't expect non Numeric parameters" do
      expect { Vector3.new(1, :a, 3) }.to raise_error(ArgumentError)
    end

    it 'expects 2 Numeric parameters' do
      expect { Vector3.new(1.0, 2.0, 3) }.not_to raise_error
    end

  end

  subject { Vector3.new(1.0, 2.0, 3.0) }

  describe 'multiplication' do

    it 'accepts a Numeric' do
      (subject * 2).should == Vector3[2.0, 4.0, 6.0]
    end

    it 'accepts a Matrix3' do
      fail
    end

    it "doesn't accept anything other than a Numeric or Matrix3" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

end