require_relative 'spec_helper'

RSpec.describe Matrix2 do

  subject { Matrix2.new(1.0, 2.0, 3.0, 4.0) }
  let(:det_zero) { Matrix2.new(1.0, 2.0, 0.0, 0.0) }
  let(:vector2)  { Vector2[1.0, 2.0] }

  describe 'initialize' do

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

    it 'works as an array initializer' do
      should == Matrix2[1.0, 2.0, 3.0, 4.0]
    end

  end

  describe 'build' do
    it { Matrix2.build { |r, c| r * Matrix2.dim + c + 1 }.should == subject }
  end

  describe 'column' do

    it 'accepts 2 arrays of size 2' do
      expect { Matrix2.columns([1.0, 2.0], [3.0, 4.0]) }.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 2" do
      expect { Matrix2.columns([1.0, 2.0]) }.to raise_error(ArgumentError)
      expect { Matrix2.columns([1.0, 2.0], [3.0, 4.0], [5.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 2" do
      expect { Matrix2.columns([1.0, 2.0, 5.0], [3.0, 4.0]) }.to raise_error(ArgumentError)
    end

    it 'accepts an Integer between 0 and 1' do
      subject.column(0).should == [subject[0, 0], subject[1, 0]]
      subject.column(1).should == [subject[0, 1], subject[1, 1]]
    end

    it "doesn't accept an Integer outside 0 and 1" do
      expect { subject.column(-1) }.to raise_error ArgumentError
      expect { subject.column( 2) }.to raise_error ArgumentError
    end

    it { subject.columns.should == [[subject[0, 0], subject[1, 0]], [subject[0, 1], subject[1, 1]]] }

  end

  describe 'diagonal' do
    it { Matrix2.diagonal(1.0, 2.0).should == Matrix2.new(1.0, 0.0, 0.0, 2.0) }

    it { subject.diagonal.should == [1.0, 4.0] }

    let(:diagonal_matrix) { Matrix2.new(2, 0, 0, 2) }

    it { diagonal_matrix.should be_diagonal }
    it { should_not be_diagonal }
  end

  describe 'dimension' do
    it { Matrix2.dimension.should == 2 }
    it { Matrix2.dim.should == Matrix2.dimension }
    it { Matrix2.zero.dimension.should == 2 }

    it { subject.dimension.should == 2 }
  end

  describe 'identity' do
    it { Matrix2.identity.should == Matrix2.new(1.0, 0.0, 0.0, 1.0) }
  end

  describe 'length' do

    it { Matrix2.length.should == 4 }
    it { subject.length.should == 4 }

  end

  describe 'row' do

    it 'accepts 2 arrays of size 2' do
      expect { Matrix2.rows([1.0, 2.0], [3.0, 4.0]) }.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 2" do
      expect { Matrix2.rows([1.0, 2.0]) }.to raise_error(ArgumentError)
      expect { Matrix2.rows([1.0, 2.0], [3.0, 4.0], [5.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 2" do
      expect { Matrix2.rows([1.0, 2.0, 5.0], [3.0, 4.0]) }.to raise_error(ArgumentError)
    end

    it 'accepts an Integer between 0 and 1' do
      subject.row(0).should == [subject[0, 0], subject[0, 1]]
      subject.row(1).should == [subject[1, 0], subject[1, 1]]
    end

    it "doesn't accept an Integer outside 0 and 1" do
      expect { subject.row(-1) }.to raise_error ArgumentError
      expect { subject.row( 2) }.to raise_error ArgumentError
    end

    it { subject.rows.should == [[subject[0, 0], subject[0, 1]], [subject[1, 0], subject[1, 1]]] }

  end

  describe 'scalar' do

    it 'should only fill the diagonal with the same value' do
      Matrix2.scalar(3.0).should == Matrix2.new(3.0, 0.0,
                                                0.0, 3.0)
    end

    it 'finds if a Matrix2 only has the diagonal filled with a single value and the rest with zero' do
      Matrix2.new(3.0, 0.0, 0.0, 3.0).should be_scalar
    end

  end

  describe 'zero' do

    it 'creates a Matrix2 filled only with zeros' do
      Matrix2.zero.should == Matrix2.new(0.0, 0.0, 0.0, 0.0)
    end

    it 'finds if the Matrix2 only has zeros' do
      Matrix2.new(0.0, 0.0, 0.0, 0.0).should be_zero
    end

  end

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

    it 'return the identity when divided by itself' do
      (subject / subject).should == subject.class.identity
    end

  end

  describe 'adjoint' do

    let(:matrix_imag) { Matrix2.new(-1.0+1i, 2.0, 0.0, 2.0-3.0i) }

    it { matrix_imag.adjoint.should == Matrix2.new(-1.0-1i, 0.0, 2.0, 2.0+3.0i) }
  end

  describe 'adjugate' do

    it do
      subject.adjugate.should == Matrix2[ subject[1, 1],
                                          -subject[0, 1],
                                          -subject[1, 0],
                                          subject[0, 0]]
    end

  end

  describe 'coerce' do
    it { subject.coerce(5.0).should == [Scalar.new(5.0), subject] }
  end

  describe 'collect' do

    it { subject.collect { |x| x }.should == subject }

    it do
      subject.collect { |x| -x }.should == Matrix2.new(-subject[0],
                                                       -subject[1],
                                                       -subject[2],
                                                       -subject[3])
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

  describe 'each' do
    it { subject.each.to_a.should == subject.to_a }

    it { subject.each(:diagonal).to_a.should == [subject[0, 0], subject[1, 1]] }

    it { subject.each(:off_diagonal).to_a.should == [subject[0, 1], subject[1, 0]] }

    it { subject.each(:lower).to_a.should == [subject[0, 0], subject[1, 0], subject[1, 1]] }

    it { subject.each(:strict_lower).to_a.should == [subject[1, 0]] }

    it { subject.each(:strict_upper).to_a.should == [subject[0, 1]] }

    it { subject.each(:upper).to_a.should == [subject[0, 0], subject[0, 1], subject[1, 1]] }

    it { expect { subject.each(:something_else).to raise_error(ArgumentError) } }
  end

  describe 'each_with_index' do
    it { subject.each_with_index.to_a.should == subject.to_a.each_with_index.map { |v, i| [v, i / subject.dim, i % subject.dim] } }

    it do
      subject.each_with_index(:diagonal).to_a.should == [ [subject[0, 0], 0, 0], [subject[1, 1], 1, 1] ]
    end

    it do
      subject.each_with_index(:off_diagonal).to_a.should == [ [subject[0, 1], 0, 1], [subject[1, 0], 1, 0] ]
    end

    it do
      subject.each_with_index(:lower).to_a.should == [ [subject[0, 0], 0, 0], [subject[1, 0], 1, 0], [subject[1, 1], 1, 1] ]
    end

    it do
      subject.each_with_index(:strict_lower).to_a.should == [ [subject[1, 0], 1, 0] ]
    end

    it do
      subject.each_with_index(:strict_upper).to_a.should == [ [subject[0, 1], 0, 1] ]
    end

    it do
      subject.each_with_index(:upper).to_a.should == [ [subject[0, 0], 0, 0], [subject[0, 1], 0, 1], [subject[1, 1], 1, 1] ]
    end

    it { expect { subject.each_with_index(:something_else).to_a }.to raise_error(ArgumentError) }
  end

  describe 'hermitian' do

    let(:hermitian) { Matrix2[1, -1i, 1i, 1] }
    it { should_not be_hermitian }
    it { hermitian.should be_hermitian }

  end

  describe 'imaginary' do

    it { subject.imaginary.should == Matrix2.zero }

    it { Matrix2.new(4+1i, 3+2i, 2+3i, 1+4i).imaginary.should == Matrix2.new(1, 2, 3, 4) }

  end

  describe 'inverse' do
    it { subject.inverse.should == subject.adjugate * (1.0 / subject.determinant) }
  end

  describe 'lower_triangular' do
    it { should_not be_lower_triangular }

    it { Matrix2.new(1, 2, 0, 4).should_not be_lower_triangular }

    it { Matrix2.new(1, 0, 3, 4).should be_lower_triangular }
  end

  describe 'lup' do

    let(:lup) { subject.lup }
    let(:lm) { lup[0] }
    let(:um) { lup[1] }
    let(:pm) { lup[2] }

    it { pm.should == Matrix2.new(0.0, 1.0, 1.0, 0.0) }

    it { should == pm.transpose * lm * um }

  end

  describe 'normal' do
    it { fail }
  end

  describe 'orthogonal' do

    it { should_not be_orthogonal }

    it { fail }
  end

  describe 'permutation' do
    it { fail }
  end

  describe 'real' do

    it { should be_real }

    it { Matrix2.new(1i, 0, 0, 0).should_not be_real }
  end

  describe 'round' do
    it { fail }
  end

  describe 'singular' do

    it { should_not be_singular }

    it { Matrix2.new(1, 1, 1, 1).should be_singular }
  end

  describe 'symmetric' do

    it { should_not be_symmetric }

    it { Matrix2.identity.should be_symmetric }

    it { Matrix2.zero.should be_symmetric }

    it { Matrix2.new(1, 2, 2, 1).should be_symmetric }
  end

  describe 'trace' do
    it { subject.trace.should == subject[0, 0] + subject[1, 1] }
  end

  describe 'transpose' do

    it do
      subject.transpose.should == Matrix2[subject[0, 0],
                                          subject[1, 0],
                                          subject[0, 1],
                                          subject[1, 1]]
    end

  end

  describe 'unitary' do
    it { fail }
  end

  describe 'upper_triangular' do
    it { should_not be_upper_triangular }

    it { Matrix2.new(1, 0, 3, 4).should_not be_upper_triangular }

    it { Matrix2.new(1, 2, 0, 4).should be_upper_triangular }
  end

  describe 'rotation' do
    it { fail }
  end

  describe 'scale' do
    it { fail }
  end

  describe 'translation' do
    it { fail }
  end

  describe 'determinant' do
    it { subject.determinant.should == subject[0, 0] * subject[1, 1] - subject[0, 1] * subject[1, 0] }
  end

  describe 'expand' do
    it { fail }
  end

end