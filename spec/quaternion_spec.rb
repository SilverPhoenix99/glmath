require_relative "spec_helper"

RSpec.describe Quaternion do

  subject { Quaternion.new(1.0, 2.0, 3.0, 4.0)}

  describe '::[]' do
    it 'creates a quaternion' do
      expect(Quaternion[2.0, 3.0, 4.0, 1.0]).to be_a(Quaternion)
    end
  end

  describe '::from_angle_axis' do
    let(:angle) { Math::PI / 2 }
    let(:axis) { Vector3::X }


    # TODO
    it 'creates a quaternion given an angle and an axis' do
      expect(Quaternion.from_angle_axis(angle, axis)).to eq Quaternion(Math.cos(angle * 0.5))
    end
  end

end