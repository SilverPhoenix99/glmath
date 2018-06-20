require_relative "spec_helper"

RSpec.describe Matrix2 do

  subject { Matrix2[1.0, 2.0, 3.0, 4.0] }
  let(:vector2)  { Vector2[1.0, 2.0] }
  let(:det_zero) { Matrix2[1.0, 2.0, 0.0, 0.0] }
  let(:scale_matrix) { Matrix2[1.0, 0.0, 0.0, 2.0] }
  let(:diagonal_matrix) { Matrix2[1.0, 0.0, 0.0, 2.0] }
  let(:scalar_matrix) { Matrix2[3.0, 0.0, 0.0, 3.0] }
  let(:subject_times_two) do
    Matrix2[subject[0, 0] * 2, subject[0, 1] * 2,
            subject[1, 0] * 2, subject[1, 1] * 2]
  end

  describe '::dimension' do
    example 'should be 2' do
      expect(Matrix2.dimension).to eq 2
    end
  end

  describe '::rotation' do
    let(:angle) { 45 * 2 * Math::PI / 360.0 }
    let(:s) { Math.sin(angle) }
    let(:c) { Math.cos(angle) }
    let(:rotation_matrix) { Matrix2[c, -s, s, c] }

    example 'should create a rotation matrix' do
      expect(Matrix2.rotation(angle)).to eq rotation_matrix
    end
  end

  describe '::scale' do
    example 'should create a scaling matrix' do
      expect(Matrix2.scale(1.0, 2.0)).to eq scale_matrix
    end
  end

  describe '::build' do
    example 'build a matrix from a block' do
      expect(Matrix2.build { |r, c| r * Matrix2.dim + c + 1 }).to eq subject
    end
  end

  describe '::diagonal' do
    example 'should create a diagonal matrix with 2 arguments' do
      expect(Matrix2.diagonal(1.0, 2.0)).to eq(diagonal_matrix)
    end
  end

  describe '::identity' do
    let(:identity) { Matrix2[1.0, 0.0, 0.0, 1.0] }

    example 'should return identity matrix' do
      expect(Matrix2.identity).to eq(identity)
    end
  end

  describe '::length' do
    example 'should return 4' do
      expect(Matrix2.length).to eq 4
    end
  end

  describe '::new' do
    it 'accepts 4 Numeric arguments' do
      expect { Matrix2[*4.times.to_a] }.not_to raise_error
    end

    it "doesn't accept more than 4 arguments" do
      expect { Matrix2[*5.times.to_a] }.to raise_error ArgumentError
    end

    it "doesn't accept less than 4 arguments" do
      expect { Matrix2[*3.times.to_a] }.to raise_error ArgumentError
    end

    it "doesn't accept anything other than Numerics" do
      expect { Matrix2[1.0, 2.0, 3.0, :a] }.to raise_error ArgumentError
    end

    it 'works as an array initializer' do
      expect(Matrix2[1.0, 2.0, 3.0, 4.0]).to be_a(Matrix2)
    end
  end

  describe '::columns' do
    it 'accepts 2 arrays of size 2' do
      expect { Matrix2.columns([1.0, 2.0], [3.0, 4.0]) }.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 2" do
      expect { Matrix2.columns([1.0, 2.0]) }.to raise_error(ArgumentError)
      expect { Matrix2.columns([1.0, 2.0], [3.0, 4.0], [5.0, 6.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 2" do
      expect { Matrix2.columns([1.0, 2.0, 5.0], [3.0, 4.0]) }.to raise_error(ArgumentError)
    end
  end

  describe '::rows' do
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
  end

  describe '::scalar' do
    example 'should only fill the diagonal with the same value' do
      expect(Matrix2.scalar(3.0)).to eq scalar_matrix
    end
  end

  describe '::zero' do
    let(:zero_matrix) { Matrix2[0.0, 0.0, 0.0, 0.0] }

    it 'creates a Matrix2 filled only with zeros' do
      expect(Matrix2.zero).to eq(zero_matrix)
    end
  end

  describe '#+' do
    it 'accepts a Matrix2' do
      expect(subject + subject).to eq subject_times_two
    end

    it "doesn't accept something other than a Matrix2" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end
  end

  describe '#-' do
    it 'accepts a Matrix2' do
      expect(subject - subject).to be_zero
    end

    it "doesn't accept something other than a Matrix2" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end
  end

  describe '#multiplication' do

    let(:vector_multiplication) do
      Vector2[subject[0, 0] * vector2.x + subject[0, 1] * vector2.y,
              subject[1, 0] * vector2.x + subject[1, 1] * vector2.y]
    end

    let(:matrix_multiplication) do
      Matrix2[subject[0, 0] * subject[0, 0] + subject[0, 1] * subject[1, 0],
              subject[0, 0] * subject[0, 1] + subject[0, 1] * subject[1, 1],
              subject[1, 0] * subject[0, 0] + subject[1, 1] * subject[1, 0],
              subject[1, 0] * subject[0, 1] + subject[1, 1] * subject[1, 1]]
    end

    it 'accepts a Numeric' do
      expect(subject * 2).to eq subject_times_two
    end

    it 'becomes zero when multiplied by zero' do
      expect(subject * 0).to be_zero
    end

    it 'accepts a Vector2' do
      expect(subject * vector2).to eq vector_multiplication
    end

    it 'accepts a Matrix2' do
      expect(subject * subject).to eq matrix_multiplication
    end

    it "doesn't accept anything other than a Numeric, Vector2 or Matrix2" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end
  end

  describe '#division' do
    let(:division_matrix) { Matrix2[subject[0,0] / 2.0, subject[0,1] / 2.0,
                                    subject[1,0] / 2.0, subject[1,1] / 2.0] }

    it 'accepts a Numeric' do
      expect(subject / 2.0).to eq division_matrix
    end

    it 'accepts a Matrix2 with a determinant different than 0' do
      expect(subject / subject).to eq(subject.class.identity)
    end

    it "doesn't accept a Matrix2 with a determinant of 0" do
      expect { subject / det_zero }.to raise_error ArgumentError
    end

    it 'return the identity when divided by itself' do
      expect(subject / subject).to eq subject.class.identity
    end
  end

  describe '#column' do
    it 'accepts an Integer between 0 and 1' do
      expect(subject.column(0)).to eq [subject[0, 0], subject[1, 0]]
      expect(subject.column(1)).to eq [subject[0, 1], subject[1, 1]]
    end

    it "doesn't accept an Integer outside 0 and 1" do
      expect { subject.column(-1) }.to raise_error ArgumentError
      expect { subject.column( 2) }.to raise_error ArgumentError
    end
  end

  describe '#columns' do
    it 'returns an array with each column as a subarray' do
      expect(subject.columns).to eq [[subject[0, 0], subject[1, 0]], [subject[0, 1], subject[1, 1]]]
    end
  end

  describe '#row' do
    it "accepts an Integer between 0 and 1" do
      expect(subject.row(0)).to eq([subject[0, 0], subject[0, 1]])
      expect(subject.row(1)).to eq([subject[1, 0], subject[1, 1]])
    end

    it "doesn't accept an Integer outside 0 and 1" do
      expect { subject.row(-1) }.to raise_error ArgumentError
      expect { subject.row( 2) }.to raise_error ArgumentError
    end
  end

  describe '#rows' do
    it 'returns an array with each row as a subarray' do
      expect(subject.rows).to eq([[subject[0, 0], subject[0, 1]], [subject[1, 0], subject[1, 1]]])
    end
  end

  describe '#dimension' do
    it 'should be 2' do
      expect(subject.dimension).to eq 2
    end
  end

  describe '#length' do
    it 'should be 4' do
      expect(subject.length).to eq 4
    end
  end

  describe '#scalar?' do
    it 'is not scalar' do
      expect(subject).not_to be_scalar
    end

    example 'finds if a Matrix2 only has the diagonal filled with a single value and the rest with zero' do
      expect(scalar_matrix).to be_scalar
    end

    example 'identity is scalar' do
      expect(Matrix2::Identity).to be_scalar
    end
  end

  describe '#adjoint' do
    let(:matrix_imag) { Matrix2[-1.0+1i, 2.0, 0.0, 2.0-3.0i] }

    it do
      expect(matrix_imag.adjoint).to eq Matrix2[-1.0-1i, 0.0, 2.0, 2.0+3.0i]
    end
  end

  describe '#adjoint!' do
    let(:matrix_imag) { Matrix2[-1.0+1i, 2.0, 0.0, 2.0-3.0i] }

    it do
      expect(matrix_imag.adjoint!).to equal matrix_imag
    end
  end

  describe '#adjugate' do
    it do
      expect(subject.adjugate).to eq (Matrix2[ subject[1, 1], -subject[0, 1],
                                              -subject[1, 0],  subject[0, 0]])
    end
  end

  describe '#coerce' do
    it do
      expect(subject.coerce(5.0)).to eq([Scalar.new(5.0), subject])
    end
  end

  describe '#collect' do
    it do
      expect(subject.collect { |x| x }).to eq(subject)
    end

    it do
      expect(subject.collect { |x| -x }).to eq(Matrix2[-subject[0], -subject[1],
                                                           -subject[2], -subject[3]])
    end
  end

  describe '#conjugate' do
    it do
      expect(subject.conjugate).to eq(Matrix2[subject[0, 0].conjugate, subject[0, 1].conjugate,
                                              subject[1, 0].conjugate, subject[1, 1].conjugate])
    end
  end

  describe '#diagonal' do
    it 'should return the matrix diagonal values'do
      expect(subject.diagonal).to eq([1.0, 4.0])
    end
  end

  describe '#diagonal?' do
    it 'should be false for non-diagonal matrices' do
      expect(subject).not_to be_diagonal
    end

    example 'diagonal matrices are diagonal' do
      expect(diagonal_matrix).to be_diagonal
    end

    example 'identity is diagonal' do
      expect(Matrix2::I).to be_diagonal
    end

    example 'scale matrices are diagonal' do
      expect(scale_matrix).to be_diagonal
    end
  end

  describe '#each' do
    it 'Iterates all over the matrix members' do
      expect(subject.each.to_a).to eq(subject.to_a)
    end

    it 'Iterates over the matrix diagonal' do
      expect(subject.each(:diagonal).to_a).to eq([subject[0, 0], subject[1, 1]])
    end

    it 'Iterates over the matrix off-diagonal' do
      expect(subject.each(:off_diagonal).to_a).to eq([subject[0, 1], subject[1, 0]])
    end

    it 'Iterates over the matrix lower triangle' do
      expect(subject.each(:lower).to_a).to eq([subject[0, 0], subject[1, 0], subject[1, 1]])
    end

    it 'Iterates over the matrix strict-lower triangle' do
      expect(subject.each(:strict_lower).to_a).to eq([subject[1, 0]])
    end

    it 'Iterates over the matrix strict-upper triangle' do
      expect(subject.each(:strict_upper).to_a).to eq([subject[0, 1]])
    end

    it 'Iterates over the matrix upper triangle' do
      expect(subject.each(:upper).to_a).to eq([subject[0, 0], subject[0, 1], subject[1, 1]])
    end

    it "doesn't accept any symbol other than those defined" do
      expect { subject.each(:something_else).to raise_error(ArgumentError) }
    end
  end

  describe '#each_with_index' do
    it do
      expect(subject.each_with_index.to_a).to eq(subject.to_a.each_with_index.map do |v, i|
        [v, i / subject.dim, i % subject.dim]
      end)
    end

    it do
      expect(subject.each_with_index(:diagonal).to_a).to eq([ [subject[0, 0], 0, 0], [subject[1, 1], 1, 1] ])
    end

    it do
      expect(subject.each_with_index(:off_diagonal).to_a).to eq([ [subject[0, 1], 0, 1], [subject[1, 0], 1, 0] ])
    end

    it do
      expect(subject.each_with_index(:lower).to_a).to eq([ [subject[0, 0], 0, 0], [subject[1, 0], 1, 0], [subject[1, 1], 1, 1] ])
    end

    it do
      expect(subject.each_with_index(:strict_lower).to_a).to eq([ [subject[1, 0], 1, 0] ])
    end

    it do
      expect(subject.each_with_index(:strict_upper).to_a).to eq([ [subject[0, 1], 0, 1] ])
    end

    it do
      expect(subject.each_with_index(:upper).to_a).to eq([ [subject[0, 0], 0, 0], [subject[0, 1], 0, 1], [subject[1, 1], 1, 1] ])
    end

    it do
      expect { subject.each_with_index(:something_else).to_a }.to raise_error(ArgumentError)
    end
  end

  describe '#hermitian' do
    let(:hermitian) { Matrix2[1, -1i, 1i, 1] }

    it do
      expect(subject).not_to be_hermitian
    end

    it do
      expect(hermitian).to be_hermitian
    end
  end

  describe '#imaginary' do
    it 'returns a zero matrix if all numbers are real' do
      expect(subject.imaginary).to eq(Matrix2.zero)
    end

    it 'returns the imaginary part of a complex number Matrix' do
      expect(Matrix2[4 + 1i, 3 + 2i, 2 + 3i, 1 + 4i].imaginary).to eq(Matrix2[1, 2, 3, 4])
    end
  end

  describe '#inverse' do
    it 'calculates the inverse matrix' do
      expect(subject.inverse).to eq(subject.adjugate * (1.0 / subject.determinant))
    end
  end

  describe '#lower_triangular?' do
    it 'is not lower_triangular' do
      expect(subject).not_to be_lower_triangular
    end

    it 'is not lower_triangular' do
      expect(Matrix2[1, 2, 0, 4]).not_to be_lower_triangular
    end

    it 'is lower_triangular' do
      expect(Matrix2[1, 0, 3, 4]).to be_lower_triangular
    end
  end

  describe '#lup' do
    let(:lup) { subject.lup }
    let(:lm) { lup[0] }
    let(:um) { lup[1] }
    let(:pm) { lup[2] }

    it do
      expect(pm).to eq(Matrix2[0.0, 1.0, 1.0, 0.0])
    end

    it do
      expect(subject).to eq(pm.transpose * lm * um)
    end
  end

  describe '#normal' do
    let(:normal) { Matrix2[1i, 0, 0, 3 - 5i] }

    it 'is not normal' do
      expect(subject).not_to be_normal
    end

    example 'Normal Matrix is normal' do
      expect(normal).to be_normal
    end
  end

  # describe :orthogonal do
  #
  #   it { should_not be_orthogonal }
  #
  # end

  describe '#permutation?' do
    let(:permutation) { Matrix2[0.0, 1.0, 1.0, 0.0] }
    
    it 'is not a permutation' do
      expect(subject).not_to be_permutation
    end

    example 'Identity is a permutation' do
      expect(Matrix2.identity).to be_permutation
    end

    example 'Permutation is a permutation' do
      expect(permutation).to be_permutation
    end
  end

  describe '#real?' do
    let(:complex_matrix) { Matrix2[1i, 0, 0, 0] }

    it 'is real' do
      expect(subject).to be_real
    end

    example 'considers complex matrices not to be real' do
      expect(complex_matrix).not_to be_real
    end
  end

  describe '#real' do
    let(:complex_matrix) { Matrix2[1 + 1i, -2 - 2i, 3 + 3i, 4 - 4i] }
    let(:real_matrix)    { Matrix2[1, -2, 3, 4] }

    it 'returns the real part of a Complex number matrix' do
      expect(complex_matrix.real).to eq real_matrix
    end
  end

  describe '#round' do
    let(:float_matrix)   { Matrix2[1.5, 2.5, 3.5, 4.5] }
    let(:rounded_matrix) { Matrix2[2, 3, 4, 5] }

    it 'rounds the matrix' do
      expect(subject.round).to eq(subject)
    end

    example 'rounds a float matrix' do
      expect(float_matrix.round).to eq(rounded_matrix)
    end
  end

  describe '#singular?' do
    let(:singular) { Matrix2[1, 1, 1, 1] }

    it 'is not singular' do
      expect(subject).not_to be_singular
    end

    example 'considers a singular matrix to be singular' do
      expect(singular).to be_singular
    end
  end

  describe '#symmetric?' do
    let(:symmetric) { Matrix2[1, 2, 2, 1] }

    it 'is symmetric' do
      expect(subject).not_to be_symmetric
    end

    example 'identity is symmetric' do
      expect(Matrix2.identity).to be_symmetric
    end

    example 'zero matrix is symetric' do
      expect(Matrix2.zero).to be_symmetric
    end

    example 'A symmetric matrix is symetric' do
      expect(symmetric).to be_symmetric
    end
  end

  describe '#trace' do
    it 'calculates the matrix trace' do
      expect(subject.trace).to eq(subject[0, 0] + subject[1, 1])
    end
  end

  describe '#transpose' do
    let(:transpose) { Matrix2[subject[0, 0], subject[1, 0],
                              subject[0, 1], subject[1, 1]] }

    it 'transposes the matrix' do
      expect(subject.transpose).to eq(transpose)
    end
  end

  describe '#upper_triangular' do
    let(:lower_triangular) { Matrix2[1, 0, 3, 4] }
    let(:upper_triangular) { Matrix2[1, 2, 0, 4] }

    it 'is not a upper triangular matrix' do
      expect(subject).not_to be_upper_triangular
    end

    example 'A lower triangular matrix is not upper triangular' do
      expect(lower_triangular).not_to be_upper_triangular
    end

    example 'A upper triangular matrix is upper triangular' do
      expect(upper_triangular).to be_upper_triangular
    end
  end

  describe '#determinant' do
    it 'calculates the determinant' do
      expect(subject.determinant).to eq(subject[0, 0] * subject[1, 1] - subject[0, 1] * subject[1, 0])
    end
  end

  describe '#expand' do
    let(:expanded_matrix) { Matrix3[subject[0], subject[1], 0.0,
                                    subject[2], subject[3], 0.0,
                                    0.0,        0.0,        1.0] }

    it 'expands the matrix with a row a column in which the last number is 1.0' do
      expect(subject.expand).to eq(expanded_matrix)
    end
  end

  describe '#zero?' do
    it 'is not a zero matrix' do
      expect(subject).not_to be_zero
    end

    example 'Zero matrix only has zeros' do
      expect(Matrix2.zero).to be_zero
    end
  end
end