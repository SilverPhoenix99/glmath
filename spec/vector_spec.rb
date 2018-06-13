require_relative 'spec_helper'

RSpec.describe Vector do

  describe '#initialize' do
    it "doesn't expect non Numeric parameters" do
      expect { Vector.new(1.0, :a) }.to raise_error(ArgumentError)
    end

    it 'expects 2 Numeric parameters' do
      expect { Vector.new(1.0, 2.0)}.not_to raise_error
    end
  end

  subject { Vector.new(1.0, 2.0) }

  describe '#angle' do
    it 'should have a 0 degree angle with itself' do
      expect(subject.angle(subject)).to eq 0
    end

    it 'should have a 90 degree angle with Vector(-2, 1)' do
      expect(subject.angle(Vector[-2, 1])).to eq (Math::PI / 2)
    end
  end

  describe '#coerce' do
    it 'works with Numbers' do
      expect(subject.coerce(1)).to eq [Scalar[1], subject]
    end

    it "doesn't work with anything but Numeric" do
      expect { subject.coerce('abc') }.to raise_error(TypeError)
    end
  end

  describe '#dup' do
    let(:dup) { subject.dup }

    it 'creates a new copy of the vector' do
      expect(dup).not_to equal subject
      expect(dup).to eq subject
    end
  end

  describe '#each' do
    it 'returns a enumerator if no block is passed' do
      expect(subject.each).to be_a(Enumerator)
    end

    it 'returns self if passed a block' do
      expect(subject.each { |x| x+ 1 }).to equal subject
    end
  end

  describe '#eql?' do
    it 'is true when compared to itself' do
      expect(subject.eql? subject).to be true
    end

    it 'is true when compared to a copy of itself' do
      expect(subject.eql? subject.dup).to be true
    end

    it 'is false when compared to a a different vector' do
      expect(subject.eql? Vector[2, 3]).to be false
    end

    it 'is false when compared to a a different class object' do
      expect(subject.eql? 'abc').to be false
    end
  end

  describe '#sum' do
    it 'accepts a Vector' do
      expect((subject + Vector[2.0, 1.0])).to eq Vector[3.0, 3.0]
    end

    it "doesn't accept objects without #to_a method" do
      expect { subject + :a }.to raise_error(NoMethodError)
    end
  end

  describe '#subtraction' do
    it 'accepts a Vector' do
      expect((subject - Vector[2.0, 1.0])).to eq Vector[-1.0, 1.0]
    end

    it "doesn't accept objects without #to_a method" do
      expect { subject - :a }.to raise_error(NoMethodError)
    end
  end

  describe '#division' do
    it 'accepts a Numeric' do
      expect(subject / 2.0).to eq Vector[subject[0] / 2.0, subject[1] / 2.0]
    end

    it "doesn't accept something other than a Numeric" do
      expect { subject / :a }.to raise_error(ArgumentError)
    end
  end

  describe '#symmetric' do
    it 'should have symetric x and y values' do
      expect(-subject).to eq Vector[-subject[0], -subject[1]]
    end
  end

  describe '#+@' do
    it 'should apply #+@ to its members' do
      expect(+subject).to eq Vector[+subject[0], +subject[1]]
    end
  end

  describe '#inner_product' do
    it 'accepts a Vector' do
      expect(subject.dot(subject)).to eq 5
    end

    it 'only accepts objects that respond to #to_a' do
      expect { subject.dot :a }.to raise_error(NoMethodError)
    end
  end

  describe '#magnitude' do
    it 'should be equal to sqrt(5)' do
      expect(subject.magnitude).to eq Math.sqrt(5)
    end
  end

  describe '#normalize' do
    it 'should return a normalized vector' do
      normalized = subject.normalize
      expect(normalized).to eq Vector[1.0 / Math.sqrt(5), 2.0 / Math.sqrt(5)]
      expect(normalized.magnitude).to eq 1.0
    end
  end

  describe '#normalize!' do
    it 'should return a normalized vector' do
      expect(subject.normalize!).to equal subject
      expect(subject.normalize!).to eq Vector[1.0 / Math.sqrt(5), 2.0 / Math.sqrt(5)]
      expect(subject.magnitude).to eq 1.0
    end
  end

  describe '#zero?' do
    it "return true if it's a zero vector" do
      expect(Vector[0.0, 0.0]).to be_zero
    end

    it "return false if it isn't a zero vector" do
      expect(subject.zero?).to be false
    end
  end

  describe '#to_s' do
    it 'returns a string' do
      expect(subject.to_s).to eq 'Vector[1.0, 2.0]'
    end

    it 'returns a string in row notation' do
      expect(subject.to_s(:row)).to eq "[1.0\t2.0]"
    end

    it 'returns a string in column notation' do
      expect(subject.to_s(:column)).to eq "1.0\n2.0"
    end

    it 'returns a string in cartesian notation' do
      expect(subject.to_s(:cartesian)).to eq '(1.0, 2.0)'
    end
  end
end
