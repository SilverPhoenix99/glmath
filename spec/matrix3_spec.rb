require_relative "spec_helper"

RSpec.describe Matrix3 do

  subject { Matrix3.new(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.0) }
  let(:vector3)  { Vector3.new(1.0, 2.0, 3.0) }
  let(:det_zero) { Matrix3.new(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0) }

  describe "initialize" do

    it "accepts 9 Numeric arguments" do
      expect { Matrix3.new(*9.times.to_a) }.not_to raise_error
    end

    it "doesn't accept more than 9 arguments" do
      expect { Matrix3.new(*10.times.to_a) }.to raise_error ArgumentError
    end

    it "doesn't accept less than 9 arguments" do
      expect { Matrix3.new(*8.times.to_a) }.to raise_error ArgumentError
    end

    it "doesn't accept anything other than Numerics" do
      expect { Matrix3.new(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, :a) }.to raise_error ArgumentError
    end

    it "works as an array initializer" do
      should == Matrix3[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.0]
    end

  end

  describe "build" do
    let(:m) { Matrix3.new(*9.times.map { |i| i + 1 }) }

    it { Matrix3.build { |r, c| r * Matrix3.dim + c + 1 }.should == m }
  end

  describe "column" do

    it "accepts 3 arrays of size 3" do
      expect { Matrix3.columns([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0]) }.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 3" do
      expect { Matrix3.columns([1.0, 2.0, 3.0]) }.to raise_error(ArgumentError)
      expect { Matrix3.columns([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0], [7.0, 8.0, 9.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 3" do
      expect { Matrix3.columns([1.0, 2.0, 5.0], [3.0, 4.0, 5.0], [5.0, 6.0]) }.to raise_error(ArgumentError)
    end

    it "accepts an Integer between 0 and 2" do
      subject.column(0).should == [subject[0, 0], subject[1, 0], subject[2, 0]]
      subject.column(1).should == [subject[0, 1], subject[1, 1], subject[2, 1]]
      subject.column(2).should == [subject[0, 2], subject[1, 2], subject[2, 2]]
    end

    it "doesn't accept an Integer outside 0 and 2" do
      expect { subject.column(-1) }.to raise_error ArgumentError
      expect { subject.column( 3) }.to raise_error ArgumentError
    end

    it do
      subject.columns.should == [[subject[0, 0], subject[1, 0], subject[2, 0]],
                                 [subject[0, 1], subject[1, 1], subject[2, 1]],
                                 [subject[0, 2], subject[1, 2], subject[2, 2]]
                                ]
    end

  end

  describe "diagonal" do
    it { Matrix3.diagonal(1.0, 2.0, 3.0).should == Matrix3.new(1.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 3.0) }

    it { subject.diagonal.should == [subject[0, 0], subject[1, 1], subject[2, 2]] }

    let(:diagonal_matrix) { Matrix3.new(2, 0, 0, 0, 2, 0, 0, 0, 2) }

    it { diagonal_matrix.should be_diagonal }
    it { should_not be_diagonal }
  end

  describe "dimension" do
    it { Matrix3.dimension.should == 3 }
    it { Matrix3.dim.should == Matrix3.dimension }
    it { Matrix3.zero.dimension.should == 3 }

    it { subject.dimension.should == 3 }
  end

  describe "identity" do
    it { Matrix3.identity.should == Matrix3.new(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0) }
  end

  describe "length" do

    it { Matrix3.length.should == 9 }
    it { subject.length.should == 9 }

  end

  describe "row" do

    it "accepts 3 arrays of size 3" do
      expect { Matrix3.rows([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0]) }.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 3" do
      expect { Matrix3.rows([1.0, 2.0, 3.0]) }.to raise_error(ArgumentError)
      expect { Matrix3.rows([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0], [7.0, 8.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 3" do
      expect { Matrix3.rows([1.0, 2.0, 5.0, 6.0], [3.0, 4.0, 6.0], [5.0, 6.0, 7.0]) }.to raise_error(ArgumentError)
    end

    it "accepts an Integer between 0 and 2" do
      subject.row(0).should == [subject[0, 0], subject[0, 1], subject[0, 2]]
      subject.row(1).should == [subject[1, 0], subject[1, 1], subject[1, 2]]
      subject.row(2).should == [subject[2, 0], subject[2, 1], subject[2, 2]]
    end

    it "doesn't accept an Integer outside 0 and 2" do
      expect { subject.row(-1) }.to raise_error ArgumentError
      expect { subject.row( 3) }.to raise_error ArgumentError
    end

    it do
      subject.rows.should == [[subject[0, 0], subject[0, 1], subject[0, 2]],
                              [subject[1, 0], subject[1, 1], subject[1, 2]],
                              [subject[2, 0], subject[2, 1], subject[2, 2]]
                             ]
    end

  end

  describe "scalar" do

    it "should only fill the diagonal with the same value" do
      Matrix3.scalar(3.0).should == Matrix3.new(3.0, 0.0, 0.0,
                                                0.0, 3.0, 0.0,
                                                0.0, 0.0, 3.0)
    end

    it "finds if a Matrix3 only has the diagonal filled with a single value and the rest with zero" do
      Matrix3.new(3.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 3.0).should be_scalar
    end

  end

  describe "zero" do

    it "creates a Matrix3 filled only with zeros" do
      Matrix3.zero.should == Matrix3.new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end

    it "finds if the Matrix3 only has zeros" do
      Matrix3.new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).should be_zero
    end

  end

  describe "sum" do

    it "accepts a Matrix3" do
      (subject + subject).should == Matrix3[subject[0, 0] * 2,
                                            subject[0, 1] * 2,
                                            subject[0, 2] * 2,
                                            subject[1, 0] * 2,
                                            subject[1, 1] * 2,
                                            subject[1, 2] * 2,
                                            subject[2, 0] * 2,
                                            subject[2, 1] * 2,
                                            subject[2, 2] * 2]
    end

    it "doesn't accept something other than a Matrix3" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end

  end

  describe "subtraction" do

    it "accepts a Matrix3" do
      (subject - subject).should be_zero
    end

    it "doesn't accept something other than a Matrix3" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end

  end

  describe "multiplication" do

    it "accepts a Numeric" do
      (subject * 2).should == Matrix3[subject[0, 0] * 2,
                                      subject[0, 1] * 2,
                                      subject[0, 2] * 2,
                                      subject[1, 0] * 2,
                                      subject[1, 1] * 2,
                                      subject[1, 2] * 2,
                                      subject[2, 0] * 2,
                                      subject[2, 1] * 2,
                                      subject[2, 2] * 2]
    end

    it "accepts a Vector3" do
      (subject * vector3).should ==
        Vector3[
          subject[0, 0] * vector3.x + subject[0, 1] * vector3.y + subject[0, 2] * vector3.z,
          subject[1, 0] * vector3.x + subject[1, 1] * vector3.y + subject[1, 2] * vector3.z,
          subject[2, 0] * vector3.x + subject[2, 1] * vector3.y + subject[2, 2] * vector3.z
        ]
    end

    it "accepts a Matrix3" do
      (subject * subject).should == Matrix3[30.0,  36.0,  39.0,
                                            66.0,  81.0,  90.0,
                                            95.0, 118.0, 133.0]
    end

    it "doesn't accept anything other than a Numeric, Vector2 or Matrix3" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end

  end

  describe "division" do

    it "accepts a Numeric" do
      (subject / 2.0).should == Matrix3[subject[0, 0] / 2.0, subject[0, 1] / 2.0, subject[0, 2] / 2.0,
                                        subject[1, 0] / 2.0, subject[1, 1] / 2.0, subject[1, 2] / 2.0,
                                        subject[2, 0] / 2.0, subject[2, 1] / 2.0, subject[2, 2] / 2.0]
    end

    it "accepts a Matrix3 with a determinant different than 0" do
      (subject / subject).should == subject.class.identity
    end

    it "doesn't accept a Matrix3 with a determinant of 0" do
      expect { subject / det_zero }.to raise_error ArgumentError
    end

    it "returns the identity when divided by itself" do
      (subject / subject).should == subject.class.identity
    end

  end

  describe "adjoint" do

    let(:matrix_imag) do
      Matrix3.new(-1.0+1i, 2.0, 0.0,
                  2.0-3.0i, 1.0, 2i,
                  3.0+2.0i, 0.0, 3.0)
    end

    it do
      matrix_imag.adjoint.should == Matrix3.new(-1.0-1i, 2.0+3.0i, 3.0-2.0i,
                                                2.0, 1.0, 0.0,
                                                0.0, -2i, 3.0)
    end
  end

  describe "adjugate" do
    #not tested
  end

  describe "coerce" do
    it { subject.coerce(5.0).should == [Scalar.new(5.0), subject] }
  end

  describe "collect" do

    it { subject.collect { |x| x }.should == subject }

    it do
      subject.collect { |x| -x }.should == Matrix3.new(-subject[0], -subject[1], -subject[2],
                                                       -subject[3], -subject[4], -subject[5],
                                                       -subject[6], -subject[7], -subject[8])
    end
  end

  describe "conjugate" do

    let(:mat) do
      Matrix3.new(-1.0+1i, 2.0, 0.0,
                  2.0-3.0i, 1.0, 2i,
                  3.0+2.0i, 0.0, 3.0)
    end

    it do
      mat.conjugate.should == Matrix3[mat[0, 0].conjugate, mat[0, 1].conjugate, mat[0, 2].conjugate,
                                      mat[1, 0].conjugate, mat[1, 1].conjugate, mat[1, 2].conjugate,
                                      mat[2, 0].conjugate, mat[2, 1].conjugate, mat[2, 2].conjugate]
    end

  end

  describe "each" do
    it { subject.each.to_a.should == subject.to_a }

    it { subject.each(:diagonal).to_a.should == [subject[0, 0], subject[1, 1], subject[2, 2]] }

    it { subject.each(:off_diagonal).to_a.should == [subject[0, 1], subject[0, 2], subject[1, 0], subject[1, 2], subject[2, 0], subject[2, 1]] }

    it { subject.each(:lower).to_a.should == [subject[0, 0], subject[1, 0], subject[1, 1]] }

    it { subject.each(:strict_lower).to_a.should == [subject[1, 0]] }

    it { subject.each(:strict_upper).to_a.should == [subject[0, 1]] }

    it { subject.each(:upper).to_a.should == [subject[0, 0], subject[0, 1], subject[1, 1]] }

    it { expect { subject.each(:something_else).to raise_error(ArgumentError) } }
  end

  describe "each_with_index" do
    it { subject.each_with_index.to_a.should == subject.to_a.each_with_index.map { |v, i| [v, i / subject.dim, i % subject.dim] } }

    it do
      subject.each_with_index(:diagonal).to_a.should == [ [subject[0, 0], 0, 0], [subject[1, 1], 1, 1], [subject[2, 2], 2, 2] ]
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

  describe "hermitian" do

    let(:hermitian) { Matrix3[1, -1i, 1i, 1] }
    it { should_not be_hermitian }
    it { hermitian.should be_hermitian }

  end

  describe "imaginary" do

    it { subject.imaginary.should == Matrix3.zero }

    it { Matrix3.new(4+1i, 3+2i, 2+3i, 1+4i).imaginary.should == Matrix3.new(1, 2, 3, 4) }

  end

  describe "inverse" do
    it { subject.inverse.should == subject.adjugate * (1.0 / subject.determinant) }
  end

  describe "lower_triangular" do
    it { should_not be_lower_triangular }

    it { Matrix3.new(1, 2, 0, 4).should_not be_lower_triangular }

    it { Matrix3.new(1, 0, 3, 4).should be_lower_triangular }
  end

  describe "lup" do

    let(:lup) { subject.lup }
    let(:lm) { lup[0] }
    let(:um) { lup[1] }
    let(:pm) { lup[2] }

    it { pm.should == Matrix3.new(0.0, 1.0, 1.0, 0.0) }

    it { should == pm.transpose * lm * um }

  end

  describe "normal" do
    it { should_not be_normal }

    it { Matrix3.new(1i, 0, 0, 3-5i).should be_normal }
  end

  describe "permutation" do
    it { should_not be_permutation }
    it { Matrix3.identity.should be_permutation }
    it { Matrix3.new(0.0, 1.0, 1.0, 0.0).should be_permutation }
  end

  describe "real" do

    it { should be_real }

    it { Matrix3.new(1i, 0, 0, 0).should_not be_real }

    it { Matrix3.new(1+1i, -2-2i, 3+3i, 4-4i).real.should == Matrix3.new(1, -2, 3, 4) }

  end

  describe "round" do
    it { subject.round.should == subject }

    it { Matrix3.new(1.5, 2.5, 3.5, 4.5).round.should == Matrix3.new(2, 3, 4, 5) }
  end

  describe "singular" do

    it { should_not be_singular }

    it { Matrix3.new(1, 1, 1, 1).should be_singular }
  end

  describe "symmetric" do

    it { should_not be_symmetric }

    it { Matrix3.identity.should be_symmetric }

    it { Matrix3.zero.should be_symmetric }

    it { Matrix3.new(1, 2, 2, 1).should be_symmetric }
  end

  describe "trace" do
    it { subject.trace.should == subject[0, 0] + subject[1, 1] }
  end

  describe "transpose" do

    it do
      subject.transpose.should == Matrix3[subject[0, 0],
                                          subject[1, 0],
                                          subject[0, 1],
                                          subject[1, 1]]
    end

  end

  describe "upper_triangular" do
    it { should_not be_upper_triangular }

    it { Matrix3.new(1, 0, 3, 4).should_not be_upper_triangular }

    it { Matrix3.new(1, 2, 0, 4).should be_upper_triangular }
  end

end