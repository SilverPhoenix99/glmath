require_relative "spec_helper"

RSpec.describe Quaternion do

  subject { Quaternion[1.0, 2.0, 3.0, 4.0]}

  let(:subject_times_two) { Quaternion[2.0, 4.0, 6.0, 8.0] }
  let(:norm) { Math.sqrt(30.0) }

  describe '::[]' do
    it 'creates a quaternion' do
      expect(Quaternion[2.0, 3.0, 4.0, 1.0]).to be_a(Quaternion)
    end
  end

  describe '::from_angle_axis' do
    let(:angle) { Math::PI / 2 }
    let(:axis) { Vector3.x }


    # TODO
    it 'creates a quaternion given an angle and an axis' do
      # expect(Quaternion.from_angle_axis(angle, axis)).to eq Quaternion.new(Math.cos(angle * 0.5))
    end
  end

  describe '::identity' do
    it 'creates an identity quaternion' do
      expect(Quaternion.identity).to eq(Quaternion[1.0, 0.0, 0.0, 0.0])
    end
  end

  # TODO
  describe '::slerp' do
    it '' do

    end
  end

  describe '#initialize' do
    it 'accepts 4 Numeric parameters' do
      expect(Quaternion.new(1, 2, 3, 4)).to eq subject
    end
  end

  describe '#+' do
    let(:subject_plus_one)  { Quaternion[2.0, 2.0, 3.0, 4.0] }

    it 'accepts Rationals' do
      expect(subject + Rational(2, 2)).to eq subject_plus_one
    end

    it 'accepts Integers' do
      expect(subject + 1).to eq subject_plus_one
    end

    it 'accepts Floats' do
      expect(subject + 1.0).to eq subject_plus_one
    end

    it 'accepts quaternions' do
      expect(subject + subject).to eq subject_times_two
    end
  end

  describe '#+' do
    let(:subject_minus_one) { Quaternion[0.0, 2.0, 3.0, 4.0] }

    it 'accepts Rationals' do
      expect(subject - Rational(2, 2)).to eq subject_minus_one
    end

    it 'accepts Integers' do
      expect(subject - 1).to eq subject_minus_one
    end

    it 'accepts Floats' do
      expect(subject - 1.0).to eq subject_minus_one
    end

    it 'accepts quaternions' do
      expect(subject - subject).to eq Quaternion[0.0, 0.0, 0.0, 0.0]
    end
  end

  describe '#*' do
    it 'accepts Integers' do
      expect(subject * 2).to eq subject_times_two
    end

    it 'accepts Floats' do
      expect(subject * 2.0).to eq subject_times_two
    end

    it 'accepts Rationals' do
      expect(subject * Rational(4, 2)).to eq subject_times_two
    end

    it 'accepts quaternions' do
      expect(subject * subject).to eq Quaternion[-28.0, 4.0, 6.0, 8.0]
    end
  end

  describe '#/' do
    let(:subject_half)  { Quaternion[0.5, 1.0, 1.5, 2.0] }

    it 'accepts Integers' do
      expect(subject / 2).to eq subject_half
    end

    it 'accepts Floats' do
      expect(subject / 2.0).to eq subject_half
    end

    it 'accepts Rationals' do
      expect(subject / Rational(4, 2)).to eq subject_half
    end

    it 'accepts quaternions' do
      expect(subject / subject).to be_a Quaternion
      # raise NotImplementedError
    end
  end

  describe '-@' do
    it 'becomes its symmetric' do
      expect(-subject).to eq Quaternion[-1.0, -2.0, -3.0, -4.0]
    end
  end

  describe '+@' do
    it 'maintains its identity' do
      expect(+subject).to eq subject
    end
  end

  describe '#==' do
    it 'should be equal to itself' do
      expect(subject).to eq Quaternion[1.0, 2.0, 3.0, 4.0]
    end
  end

  describe '#w' do
    it 'should be 1' do
      expect(subject.w).to eq 1
    end
  end

  describe '#x' do
    it 'should be 2' do
      expect(subject.x).to eq 2
    end
  end

  describe '#y' do
    it 'should be 3' do
      expect(subject.y).to eq 3
    end
  end

  describe '#z' do
    it 'should be 4' do
      expect(subject.z).to eq 4
    end
  end

  describe '#angle' do
    it 'should be 0' do
      expect(subject.angle).to eq 0.0
    end
  end

  # TODO
  describe '#axis' do
    it '' do

    end
  end

  describe '#conjugate' do
    it 'calculates the conjugate' do
      expect(subject.conjugate).to eq Quaternion[1.0, -2.0, -3.0, -4.0]
    end
  end

  describe '#difference' do
    it 'onlly accepts quaternions' do
      expect { subject.difference(2) }.to raise_error(ArgumentError)
    end

    # TODO
    # it 'returns the inverse' do
    #   expect(subject.difference(subject)).to eq(Quaternion[1.0, -2.0, -3.0, -4.0] / Math.sqrt(30.0))
    # end
  end

  describe '#dot_product' do
    let(:inner_product) { subject.dot(subject) }

    it 'should be 30' do
      expect(inner_product).to eq 30
      expect(inner_product).to eq subject.squared_norm
    end

    it 'only accepts quaternions' do
      expect { subject.dot(2) }.to raise_error(ArgumentError)
    end
  end

  # TODO
  describe '#exp' do
    it '' do

    end
  end

  describe '#imaginary' do
    it 'should be [2.0, 3.0, 4.0]' do
      expect(subject.imaginary).to eq [2.0, 3.0, 4.0]
    end
  end

  describe '#inverse' do
    it 'returns the inverse' do
      expect(subject.inverse).to eq(Quaternion[1.0, -2.0, -3.0, -4.0] / norm)
    end
  end

  # TODO
  describe '#log' do
    it '' do

    end
  end

  describe '#norm' do
    it 'calculates the norm' do
      expect(subject.norm).to eq norm
    end
  end

  describe '#normalize' do
    it 'should be normalized' do
      expect(subject.normalize).to eq subject / norm
    end
  end

  # TODO
  describe '#power' do
    it '' do

    end
  end

  describe '#real?' do
    it 'should be false' do
      expect(subject).not_to be_real
    end
  end

  # TODO
  describe '#rotate' do
    it 'should be ' do

    end
  end

  describe '#squared_norm' do
    it 'should be 30' do
      expect(subject.squared_norm).to eq 30
      expect(subject.squared_norm).to eq subject.dot(subject)
    end
  end

  describe 'to_a' do
    it 'should be [1.0, 2.0, 3.0, 4.0]' do
      expect(subject.to_a).to eq [1.0, 2.0, 3.0, 4.0]
    end
  end

  #TODO
  describe '#to_angle_axis' do
    it '' do

    end
  end

  describe '#to_s' do
    it 'transforms into regular notation string' do
      expect(subject.to_s).to eq "<Quaternion(1.0, [2.0, 3.0, 4.0])>"
    end

    it 'transforms into scalar notation string' do
      expect(subject.to_s(:scalar)).to eq "<Quaternion(w: 1.0, x: 2.0, y: 3.0, z: 4.0)>"
    end

    it 'transforms into vertical notation string' do
      expect(subject.to_s(:vertical)).to eq "w: 1.0\nx: 2.0\ny: 3.0\nz: 4.0"
    end
  end

  describe '#to_matrix' do
    it 'converts into a matrix' do
      expect(subject.to_matrix).to eq Matrix4[-49,   4,  22, 0,
                                               20, -39,  20, 0,
                                               10,  28, -25, 0,
                                                0,   0,   0, 1]
    end
  end

end