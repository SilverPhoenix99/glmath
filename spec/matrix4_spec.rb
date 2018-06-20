require_relative "spec_helper"

RSpec.describe GLMath::Matrix4 do

  subject do
    Matrix4[ 1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0]
  end

  let(:complex_matrix) do
    Matrix4[1 + 1i, -2 - 2i, 3 + 3i, 4 - 4i,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0]
  end

  let(:diagonal_matrix) do
    Matrix4[1.0, 0.0, 0.0, 0.0,
            0.0, 2.0, 0.0, 0.0,
            0.0, 0.0, 3.0, 0.0,
            0.0, 0.0, 0.0, 4.0]
  end

  let(:det_zero) { Matrix4[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0] }

  let(:identity) do
    Matrix4[1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0]
  end

  let(:scalar_matrix) do
    Matrix4[3.0, 0.0, 0.0, 0.0,
            0.0, 3.0, 0.0, 0.0,
            0.0, 0.0, 3.0, 0.0,
            0.0, 0.0, 0.0, 3.0]
  end

  let(:zero_matrix) do
    Matrix4[0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0]
  end

  let(:lower_triangular) do
    Matrix4[ 1.0,  0.0,  0.0,  0.0,
             5.0,  6.0,  0.0,  0.0,
             9.0, 10.0, 11.0,  0.0,
            13.0, 14.0, 15.0, 16.0]
  end

  let(:upper_triangular) do
    Matrix4[1.0, 2.0,  3.0,  4.0,
            0.0, 6.0,  7.0,  8.0,
            0.0, 0.0, 11.0, 12.0,
            0.0, 0.0,  0.0, 16.0]
  end

  let :negative_subject do
    Matrix4[ -subject[0],  -subject[1],  -subject[2], -subject[3],
             -subject[4],  -subject[5],  -subject[6], -subject[7],
             -subject[8],  -subject[9], -subject[10], -subject[11],
            -subject[12], -subject[13], -subject[14], -subject[15]]
  end

  let :subject_times_two do
    Matrix4[ subject[0] * 2,  subject[1] * 2,  subject[2] * 2,  subject[3] * 2,
             subject[4] * 2,  subject[5] * 2,  subject[6] * 2,  subject[7] * 2,
             subject[8] * 2,  subject[9] * 2, subject[10] * 2, subject[11] * 2,
            subject[12] * 2, subject[13] * 2, subject[14] * 2, subject[15] * 2]
  end

  let(:subject_half) do
    Matrix4[ subject[0] / 2,  subject[1] / 2,  subject[2] / 2,  subject[3] / 2,
             subject[4] / 2,  subject[5] / 2,  subject[6] / 2,  subject[7] / 2,
             subject[8] / 2,  subject[9] / 2, subject[10] / 2, subject[11] / 2,
            subject[12] / 2, subject[13] / 2, subject[14] / 2, subject[15] / 2]
  end

  let(:vector4)  { Vector4[1.0, 2.0, 3.0, 4.0] }

  describe '#initialize' do
    it('accepts 16 Numeric arguments') { expect { Matrix4[*16.times.to_a] }.not_to raise_error }

    it("doesn't accept more than 16 arguments") { expect { Matrix4[*17.times.to_a] }.to raise_error ArgumentError }

    it("doesn't accept less than 16 arguments") { expect { Matrix4[*15.times.to_a] }.to raise_error ArgumentError }

    it "doesn't accept anything other than Numerics" do
      expect { Matrix4[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, :a] }.to raise_error ArgumentError
    end

    it('works as an array initializer') { expect{ Matrix4[*16.times.to_a] }.not_to raise_error }
  end

  describe '::build' do
    let(:m) { Matrix4.new(*16.times.map { |i| i + 1 }) }

    it 'builds a matrix with a given block' do
      expect(Matrix4.build { |r, c| r * Matrix4.dim + c + 1 }).to eq(m)
    end
  end

  describe '::columns' do
    it 'accepts 4 arrays of size 4' do
      expect do
        Matrix4.columns(
            [1.0, 2.0, 3.0, 1.0],
            [3.0, 4.0, 5.0, 1.0],
            [5.0, 6.0, 7.0, 1.0],
            [5.0, 6.0, 7.0, 1.0])
      end.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 4" do
      expect { Matrix4.columns([1.0, 2.0, 3.0]) }.to raise_error(ArgumentError)
      expect { Matrix4.columns([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0], [7.0, 8.0, 9.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 4" do
      expect { Matrix4.columns([1.0, 2.0, 5.0], [3.0, 4.0, 5.0], [5.0, 6.0]) }.to raise_error(ArgumentError)
    end
  end

  describe '::diagonal' do
    it 'builds a diagonal matrix form the supplied numbers' do
      expect(Matrix4.diagonal(1.0, 2.0, 3.0, 4.0)).to eq(diagonal_matrix)
    end
  end

  describe '::dimension' do
    it('returns the Matrix4 dimension') { expect(Matrix4.dimension).to eq(4) }
  end

  describe '::identity' do
    it 'builds an identity matrix' do
      expect(Matrix4.identity).to eq(identity)
    end
  end

  describe '::length' do
    it 'returns the matrix length' do
      expect(Matrix4.length).to eq(16)
    end
  end

  describe '::row' do
    it 'accepts 4 arrays of size 4' do
      expect do
        Matrix4.rows([1.0, 2.0, 3.0, 1.0],
                     [3.0, 4.0, 5.0, 1.0],
                     [5.0, 6.0, 7.0, 1.0],
                     [5.0, 6.0, 7.0, 1.0])
      end.to_not raise_error
    end

    it "doesn't accept arrays that aren't length 4" do
      expect { Matrix4.rows([1.0, 2.0, 3.0]) }.to raise_error(ArgumentError)
      expect { Matrix4.rows([1.0, 2.0, 3.0], [3.0, 4.0, 5.0], [5.0, 6.0, 7.0], [7.0, 8.0]) }.to raise_error(ArgumentError)
    end

    it "doesn't accept subarrays that aren't length 4" do
      expect { Matrix4.rows([1.0, 2.0, 5.0, 6.0], [3.0, 4.0, 6.0], [5.0, 6.0, 7.0]) }.to raise_error(ArgumentError)
    end
  end

  describe '::scalar' do
    it 'should only fill the diagonal with the same value' do
      expect(Matrix4.scalar(3.0)).to eq(scalar_matrix)
    end
  end

  describe '::zero' do
    it 'creates a Matrix4 filled only with zeros' do
      expect(Matrix4.zero).to eq(zero_matrix)
    end
  end

  describe '#+' do
    it 'accepts a Matrix4' do
      expect(subject + subject).to eq(subject_times_two)
    end

    it "doesn't accept something other than a Matrix4" do
      expect { subject + :a }.to raise_error(ArgumentError)
    end
  end

  describe '#-' do
    it 'accepts a Matrix4' do
      expect(subject - subject).to be_zero
    end

    it "doesn't accept something other than a Matrix4" do
      expect { subject - :a }.to raise_error(ArgumentError)
    end
  end

  describe '#*' do
    let :multiplication_by_vector do
      Vector4[
          subject[0, 0] * vector3.x + subject[0, 1] * vector3.y + subject[0, 2] * vector3.z,
          subject[1, 0] * vector3.x + subject[1, 1] * vector3.y + subject[1, 2] * vector3.z,
          subject[2, 0] * vector3.x + subject[2, 1] * vector3.y + subject[2, 2] * vector3.z
      ]
    end

    let(:squared_subject) { Matrix4[30.0,  36.0,  39.0, 66.0,  81.0,  90.0, 95.0, 118.0, 133.0] }

    it 'accepts a Numeric' do
      expect(subject * 2).to eq(subject_times_two)
    end

    it 'accepts a Vector4' do
      expect(subject * vector4).to eq(multiplication_by_vector)
    end

    it 'accepts a Matrix4' do
      expect(subject * subject).to eq(squared_subject)
    end

    it "doesn't accept anything other than a Numeric, Vector2 or Matrix4" do
      expect { subject * :a }.to raise_error(ArgumentError)
    end
  end

  describe '#/' do
    it 'accepts a Numeric' do
      expect(subject / 2.0).to eq(subject_half)
    end

    it 'accepts a Matrix4 with a determinant different than 0' do
      expect(subject / Matrix4.identity).to eq(subject)
    end

    it 'doesn\'t accept a Matrix4 with a determinant of 0' do
      expect { Matrix4.identity / subject }.to raise_error ArgumentError
    end

    it 'returns the identity when divided by itself and determinant is not zero' do
      expect(Matrix4.identity / Matrix4.identity).to eq(subject.class.identity)
    end
  end

  describe '#adjoint' do
    let(:matrix_imag) do
      Matrix4[-1.0 + 1.0i, 2.0, 0.0,
              2.0 - 3.0i, 1.0,  2i,
              3.0 + 2.0i, 0.0, 3.0]
    end

    let(:adjoint) do
      Matrix4[-1.0 - 1i, 2.0 + 3.0i, 3.0 - 2.0i,
              2.0,        1.0,        0.0,
              0.0,        -2i,        3.0]
    end

    it do
      expect(matrix_imag.adjoint).to eq(adjoint)
    end
  end

  describe '#adjugate' do
    #not tested
  end

  describe '#coerce' do
    it do
      expect(subject.coerce(5.0)).to eq([Scalar.new(5.0), subject])
    end
  end

  describe '#column' do
    it 'accepts an Integer between 0 and 3' do
      expect(subject.column(0)).to eq([subject[0, 0], subject[1, 0], subject[2, 0], subject[3, 0]])
      expect(subject.column(1)).to eq([subject[0, 1], subject[1, 1], subject[2, 1], subject[3, 1]])
      expect(subject.column(2)).to eq([subject[0, 2], subject[1, 2], subject[2, 2], subject[3, 2]])
      expect(subject.column(3)).to eq([subject[0, 3], subject[1, 3], subject[2, 3], subject[3, 3]])
    end

    it "doesn't accept an Integer outside 0 and 3" do
      expect { subject.column(-1) }.to raise_error ArgumentError
      expect { subject.column( 4) }.to raise_error ArgumentError
    end
  end

  describe '#columns' do
    it do
      expect(subject.columns).to eq([[subject[0, 0], subject[1, 0], subject[2, 0], subject[3, 0]],
                                     [subject[0, 1], subject[1, 1], subject[2, 1], subject[3, 1]],
                                     [subject[0, 2], subject[1, 2], subject[2, 2], subject[3, 2]],
                                     [subject[0, 3], subject[1, 3], subject[2, 3], subject[3, 3]]])
    end
  end

  describe '#collect' do
    it do
      expect(subject.collect { |x| x }).to eq(subject)
    end

    it do
      expect(subject.collect { |x| -x }).to eq(negative_subject)
    end
  end

  #TODO
  describe '#conjugate' do
    let(:conjugate_matrix) do
      Matrix4.new(-1.0+1i, 2.0, 0.0,
                  2.0-3.0i, 1.0, 2i,
                  3.0+2.0i, 0.0, 3.0)
    end

    it do
      conjugate_matrix.conjugate.to eq(Matrix4[mat[0, 0].conjugate, mat[0, 1].conjugate, mat[0, 2].conjugate,
                                      mat[1, 0].conjugate, mat[1, 1].conjugate, mat[1, 2].conjugate,
                                      mat[2, 0].conjugate, mat[2, 1].conjugate, mat[2, 2].conjugate])
    end
  end

  describe '#diagonal' do
    it 'returns the diagonal of a matrix as an array' do
      expect(subject.diagonal).to eq([subject[0, 0], subject[1, 1], subject[2, 2], subject[3, 3]])
    end
  end

  describe '#diagonal?' do
    it 'is not a diagonal matrix' do
      expect(subject).not_to be_diagonal
    end

    example 'Diagonal matrices are diagonal' do
      expect(diagonal_matrix).to be_diagonal
    end

    example 'Scalar matrices are diagonal' do
      expect(scalar_matrix).to be_diagonal
    end
  end

  describe('#dimension') do
    it 'should be 4' do
      expect(subject.dimension).to eq(4)
    end
  end

  describe '#each' do
    it do
      expect(subject.each.to_a).to eq(subject.to_a)
    end

    it do
      expect(subject.each(:diagonal).to_a).to eq([subject[0, 0], subject[1, 1], subject[2, 2], subject[3, 3]])
    end

    it do
      expect(subject.each(:off_diagonal).to_a).
          to eq([subject[0, 1], subject[0, 2], subject[0, 3],
                 subject[1, 0], subject[1, 2], subject[1, 3],
                 subject[2, 0], subject[2, 1], subject[2, 3],
                 subject[3, 0], subject[3, 1], subject[3, 2]])
    end

    it do
      expect(subject.each(:lower).to_a).
          to eq([subject[0, 0], subject[1, 0], subject[1, 1], subject[2, 0], subject[2, 1],
                 subject[2, 2], subject[3, 0], subject[3, 1], subject[3, 2], subject[3, 3]])
    end

    it do
      expect(subject.each(:strict_lower).to_a).
          to eq([subject[1, 0], subject[2, 0], subject[2, 1], subject[3, 0], subject[3, 1], subject[3, 2]])
    end

    it do
      expect(subject.each(:strict_upper).to_a).
          to eq([subject[0, 1], subject[0, 2], subject[0, 3], subject[1, 2], subject[1, 3], subject[2, 3]])
    end

    it do
      expect(subject.each(:upper).to_a).
          to eq([subject[0, 0], subject[0, 1], subject[0, 2], subject[0, 3], subject[1, 1],
                 subject[1, 2], subject[1, 3], subject[2, 2], subject[2, 3], subject[3, 3]])
    end

    it do
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
      expect(subject.each_with_index(:diagonal).to_a).
          to eq([ [subject[0, 0], 0, 0], [subject[1, 1], 1, 1], [subject[2, 2], 2, 2], [subject[3, 3], 3, 3] ])
    end

    it do
      expect(subject.each_with_index(:off_diagonal).to_a).to eq([ [subject[0, 1], 0, 1], [subject[1, 0], 1, 0] ])
    end

    it do
      expect(subject.each_with_index(:lower).to_a).
          to eq([ [subject[0, 0], 0, 0], [subject[1, 0], 1, 0], [subject[1, 1], 1, 1] ])
    end

    it do
      expect(subject.each_with_index(:strict_lower).to_a).to eq([ [subject[1, 0], 1, 0] ])
    end

    it do
      expect(subject.each_with_index(:strict_upper).to_a).to eq([ [subject[0, 1], 0, 1] ])
    end

    it do
      expect(subject.each_with_index(:upper).to_a).
          to eq([ [subject[0, 0], 0, 0], [subject[0, 1], 0, 1], [subject[1, 1], 1, 1] ])
    end

    it do
      expect { subject.each_with_index(:something_else).to_a }.to raise_error(ArgumentError)
    end
  end

  describe '#hermitian?' do
    let(:hermitian) { Matrix4[-1, 1 - 2i, 0, 1 + 2i, 0, -1i, 0, 1i, 1] }

    it 'is not an hermitian matrix' do
      expect(subject).not_to be_hermitian
    end

    example 'Hermitian matrix should be considered hermitian' do
      expect(hermitian).to be_hermitian
    end
  end

  describe '#imaginary' do
    it 'has no imaginary part' do
      expect(subject.imaginary).to eq(Matrix4.zero)
    end

    it 'has imaginary part' do
      expect(complex_matrix.imaginary).to eq Matrix4[1, -2, 3, -4,
                                                     0,  0, 0,  0,
                                                     0,  0, 0,  0,
                                                     0,  0, 0,  0]
    end
  end

  # TODO
  describe '#inverse' do
    it 'if determinant is zero has no inverse' do
      expect{ subject.inverse }.to raise_error(ArgumentError)
    end

    example 'the inverse of identity is itself' do
      expect(Matrix4.identity.inverse).to eq Matrix4.identity
    end
  end

  describe '#length' do
    it 'returns the matrix length' do
      expect(subject.length).to eq(16)
    end
  end

  describe '#lower_triangular?' do
    it "isn't lower triangular" do
      expect(subject).not_to be_lower_triangular
    end

    example 'lower triangular matrices are lower triangular' do
      expect(lower_triangular).to be_lower_triangular
    end

    example 'upper triangular matrices are not lower triangular' do
      expect(upper_triangular).not_to be_lower_triangular
    end

    example 'Identity is lower triangular' do
      expect(Matrix4::Identity).to be_lower_triangular
    end

    example 'Diagonal matrices are lower triangular' do
      expect(diagonal_matrix).to be_lower_triangular
    end

    example 'Scalar matrices are lower triangular' do
      expect(scalar_matrix).to be_lower_triangular
    end
  end

  describe 'lup' do
    let(:lup) { subject.lup }
    let(:lm) { lup[0] }
    let(:um) { lup[1] }
    let(:pm) { lup[2] }

    it do
      expect(subject.lup).to eq([lm, um, pm])
    end

    it do
      expect(pm).to eq(Matrix4[0.0, 1.0, 1.0, 0.0])
    end

    it do
      expect(subject).to eq(pm.transpose * lm * um)
    end

  end

  describe '#normal?' do
    let(:normal_matrix) { Matrix4[0, -0.8, -0.6, 0.8, -0.36, 0.48, 0.6, 0.48, -0.64] }

    it 'is not normal' do
      expect(subject).not_to be_normal
    end

    example 'Normal matrices are normal matrix' do
      expect(normal_matrix).to be_normal
    end
  end

  describe '#permutation?' do
    let(:permutation_matrix) do
      Matrix4[0.0, 1.0, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0,
              0.0, 0.0, 0.0, 1.0,
              1.0, 0.0, 0.0, 0.0]
    end

    it 'is not a permutation matrix' do
      expect(subject).not_to be_permutation
    end

    example 'identity is a permutation matrix' do
      expect(Matrix4::Identity).to be_permutation
    end

    example 'permutation matrices are considered permutations' do
      expect(permutation_matrix).to be_permutation
    end
  end

  describe '#real' do
    let(:real_part) do
      Matrix4[1, -2, 3, 4,
              0,  0, 0, 0,
              0,  0, 0, 0,
              0,  0, 0, 0]
    end

    it 'takes the real part of a matrix' do
      expect(complex_matrix.real).to eq real_part
    end
  end

  describe '#real?' do
    it 'is composed of real numbers' do
      expect(subject).to be_real
    end

    example 'complex matrices are not real' do
      expect(complex_matrix).not_to be_real
    end
  end

  describe 'round' do
    let(:round_matrix) do
      Matrix4[1.0, 1.0, 2.0, 2.0,
              3.0, 3.0, 4.0, 4.0,
              5.0, 5.0, 6.0, 6.0,
              7.0, 7.0, 8.0, 8.0]
    end

    it 'is already rounded' do
      expect(subject.round).to eq(subject)
    end

    example 'rounds the matrix' do
      expect(subject_half.round).to eq(round_matrix)
    end
  end

  describe '#row' do
    it 'accepts an Integer between 0 and 3' do
      expect(subject.row(0)).to eq([subject[0, 0], subject[0, 1], subject[0, 2], subject[0, 3]])
      expect(subject.row(1)).to eq([subject[1, 0], subject[1, 1], subject[1, 2], subject[1, 3]])
      expect(subject.row(2)).to eq([subject[2, 0], subject[2, 1], subject[2, 2], subject[2, 3]])
      expect(subject.row(3)).to eq([subject[3, 0], subject[3, 1], subject[3, 2], subject[3, 3]])
    end

    it "doesn't accept an Integer outside 0 and 3" do
      expect { subject.row(-1) }.to raise_error ArgumentError
      expect { subject.row( 4) }.to raise_error ArgumentError
    end
  end

  describe '#rows' do
    it do
      expect(subject.rows).to eq([[subject[0, 0], subject[0, 1], subject[0, 2], subject[0, 3]],
                                  [subject[1, 0], subject[1, 1], subject[1, 2], subject[1, 3]],
                                  [subject[2, 0], subject[2, 1], subject[2, 2], subject[2, 3]],
                                  [subject[3, 0], subject[3, 1], subject[3, 2], subject[3, 3]]])
    end
  end

  describe '#scalar?' do
    it 'is not scalar' do
      expect(subject).not_to be_scalar
    end

    example 'finds if a Matrix4 only has the diagonal filled with a single value and the rest with zero' do
      expect(scalar_matrix).to be_scalar
    end

    example 'identity is scalar' do
      expect(Matrix4::Identity).to be_scalar
    end
  end

  describe '#singular' do
    it 'is not singular' do
      expect(subject).to be_singular
    end

    example 'Identity is not singular' do
      expect(Matrix4.identity).not_to be_singular
    end
  end

  describe '#symmetric' do
    let(:symmetric_matrix) do
      Matrix4[1, 2, 3, 4,
              2, 3, 4, 3,
              3, 4, 3, 2,
              4, 3, 2, 1]
    end

    it 'is not symmetric' do
      expect(subject).not_to be_symmetric
    end

    example 'identity is symmetric' do
      expect(Matrix4::Identity).to be_symmetric
    end

    it 'zero matrices are symetric' do
      expect(Matrix4.zero).to be_symmetric
    end

    it 'symmetric matrices are symmetric' do
      expect(symmetric_matrix).to be_symmetric
    end
  end

  describe '#trace' do
    it 'calculates the matrix trace' do
      expect(subject.trace).to eq(subject[0, 0] + subject[1, 1] + subject[2, 2] + subject[3, 3])
    end
  end

  describe '#transpose' do
    let(:transpose_subject) { Matrix4[1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16] }

    it 'transposes the matrix' do
      expect(subject.transpose).to eq(transpose_subject)
    end
  end

  describe '#upper_triangular' do
    it 'is not upper triangular' do
      expect(subject).not_to be_upper_triangular
    end

    example 'lower triangular are not upper triangular' do
      expect(lower_triangular).not_to be_upper_triangular
    end

    example 'upper triangular are upper triangular' do
      expect(upper_triangular).to be_upper_triangular
    end

    example 'identity is upper triangular' do
      expect(Matrix4::Identity).to be_upper_triangular
    end

    example 'diagonal matrix is upper triangular' do
      expect(diagonal_matrix).to be_upper_triangular
    end

    example 'scalar matrix is upper triangular' do
      expect(scalar_matrix).to be_upper_triangular
    end
  end

  describe '#zero?' do
    it 'should be a zero matrix' do
      expect(subject).not_to be_zero
    end

    example 'finds if the Matrix4 only has zeros' do
      expect(Matrix4.zero).to be_zero
    end

    example 'scalar 0 matrix is zero' do
      expect(Matrix4.scalar(0)).to be_zero
    end

    example 'diagonal 0, 0, 0 is zero' do
      expect(Matrix4.diagonal(0, 0, 0, 0)).to be_zero
    end
  end
end