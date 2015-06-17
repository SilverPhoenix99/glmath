require_relative 'spec_helper'

RSpec.describe Matrix2 do

  it { Matrix2.dimension.should == 2 }

  describe 'diagonal' do
    it { Matrix2.diagonal(1.0, 2.0).should == Matrix2[1.0, 0.0, 0.0, 2.0] }
  end

  describe 'identity' do
    it { Matrix2.identity.should == Matrix2[1.0, 0.0, 0.0, 1.0] }
  end

  describe '#initialize' do

    it 'accepts a 4 sized Array' do
      expect { Matrix2.new([1.0, 2.0, 3.0, 4.0]) }.not_to raise_error
    end

    it "doesn't accept a 4 sized Array" do
      expect { Matrix2.new([1.0, 2.0, 3.0, 4.0, 5.0]) }.to raise_error ArgumentError
    end

    it 'accepts 4 Numeric' do
      expect { Matrix2.new(1.0, 2.0, 3.0, 4.0) }.not_to raise_error
    end

    it "doesn't accept anything other than a 4 sized Array or 4 Numerics" do
      expect { Matrix2.new(:a) }.to raise_error ArgumentError
    end

  end

  subject { Matrix2.new(1.0, 2.0, 3.0, 4.0) }

  describe 'sum' do

    it 'accepts a Matrix2' do
      (subject + subject).should == Matrix2[subject[0,0] * 2,
                                            subject[0,1] * 2,
                                            subject[1,0] * 2,
                                            subject[1,1] * 2]
    end

    it "doesnt accept something other than a Matrix2" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

  describe 'subtraction' do

    it 'accepts a Matrix2' do
      (subject - subject).should.zero?
    end

    it "doesnt accept something other than a Matrix2" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

end