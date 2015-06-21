require_relative 'spec_helper'

RSpec.describe Matrix2 do

  it { Matrix2.dimension.should == 2 }
  it { Matrix2.zero.dimension.should == 2 }

  describe 'diagonal' do
    it { Matrix2.diagonal(1.0, 2.0).should == Matrix2[1.0, 0.0, 0.0, 2.0] }
  end

  describe 'identity' do
    it { Matrix2.identity.should == Matrix2[1.0, 0.0, 0.0, 1.0] }
  end

  describe '#initialize' do

    it 'accepts a 4 sized Array' do
      expect { Matrix2.new(1.0, 2.0, 3.0, 4.0) }.not_to raise_error
    end

    it "doesn't accept a 4 sized Array" do
      expect { Matrix2.new(1.0, 2.0, 3.0, 4.0, 5.0) }.to raise_error ArgumentError
    end

    it 'accepts 4 Numeric' do
      expect { Matrix2.new(1.0, 2.0, 3.0, 4.0) }.not_to raise_error
    end

    it "doesn't accept anything other than a 4 sized Array or 4 Numerics" do
      expect { Matrix2.new(:a) }.to raise_error ArgumentError
    end

  end

  subject { Matrix2.new(1.0, 2.0, 3.0, 4.0) }

  let(:det_zero) { Matrix2.new(1.0, 2.0, 0.0, 0.0) }
  let(:vector2)  { Vector2[1.0, 2.0] }

  describe 'sum' do

    it 'accepts a Matrix2' do
      (subject + subject).should == Matrix2[subject[0,0] * 2,
                                            subject[0,1] * 2,
                                            subject[1,0] * 2,
                                            subject[1,1] * 2]
    end

    it "doesn't accept something other than a Matrix2" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end

  end

  describe 'subtraction' do

    it 'accepts a Matrix2' do
      (subject - subject).should be_zero
    end

    it "doesn't accept something other than a Matrix2" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

  describe 'multiplication' do

    it 'accepts a Numeric' do
      (subject * 2).should == Matrix2[subject[0,0] * 2,
                                      subject[0,1] * 2,
                                      subject[1,0] * 2,
                                      subject[1,1] * 2]
    end

    it 'accepts a Vector2' do
      (subject * vector2).should == Vector2[subject[0,0] * vector2.x + subject[0,1] * vector2.y,
                                            subject[1,0] * vector2.x + subject[1,1] * vector2.y]
    end

    it 'accepts a Matrix2' do
      (subject * subject).should == Matrix2[subject[0,0] * subject[0,0] + subject[0,1] * subject[1,0],
                                            subject[0,0] * subject[0,1] + subject[0,1] * subject[1,1],
                                            subject[1,0] * subject[0,0] + subject[1,1] * subject[1,0],
                                            subject[1,0] * subject[0,1] + subject[1,1] * subject[1,1]]
    end

    it "doesn't accept anything other than a Numeric, Vector2 or Matrix2" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

  describe 'conjugate' do

    it do
      subject.conjugate.should == Matrix2[subject[0, 0].conjugate,
                                          subject[0, 1].conjugate,
                                          subject[1, 0].conjugate,
                                          subject[1, 1].conjugate]
    end

  end

  describe 'transpose' do

    it do
      subject.transpose.should == Matrix2[subject[0, 0],
                                          subject[1, 0],
                                          subject[0, 1],
                                          subject[1, 1]]
    end

  end

  describe 'inverse' do
    it "doesn't have inverse if determinant is 0" do
      expect { det_zero.inverse }.to raise_error ArgumentError
    end

    it { subject.inverse.should == subject.adjoint * (1.0 / subject.determinant) }
  end

  describe 'division' do

    it 'accepts a Numeric' do
      (subject / 2.0).should == Matrix2[subject[0,0] / 2.0,
                                        subject[0,1] / 2.0,
                                        subject[1,0] / 2.0,
                                        subject[1,1] / 2.0]
    end

    it 'accepts a Matrix2 with a determinant different than 0' do
      (subject / subject).should == subject * subject.inverse
    end

    it "doesn't accept a Matrix2 with a determinant of 0" do
      expect { subject / det_zero }.to raise_error ArgumentError
    end

  end

  describe 'determinant' do

    it { subject.determinant.should == subject[0,0] * subject[1,1] - subject[0,1] * subject[1,0] }

  end

  describe 'diagonal' do

    it { subject.diagonal.should == [1.0, 4.0] }

  end

  describe 'diagonal?' do

    let(:diagonal_matrix) { Matrix2.scalar(2) }

    it { diagonal_matrix.should be_diagonal }
    it { should_not be_diagonal }

  end

  describe 'adjugate' do

    it do
      subject.adjugate.should == Matrix2[ subject[1, 1],
                                         -subject[0, 1],
                                         -subject[1, 0],
                                          subject[0, 0]]
    end

  end

  describe 'column' do

    it 'accepts an Integer between 0 and 1' do
      subject.column(0).should == [subject[0, 0], subject[1, 0]]
    end

    it "doesn't accept an Integer outside 0 and 1" do
      expect { subject.column(-1) }.to raise_error ArgumentError
      expect { subject.column( 2) }.to raise_error ArgumentError
    end

    it { subject.columns.should == [[subject[0, 0], subject[1, 0]], [subject[0, 1], subject[1, 1]]] }

  end

  describe 'hermitian' do

    # let(:hermitian) { Matrix2. }
    it { subject.should_not be_hermitian }

  end

end