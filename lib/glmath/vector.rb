module GLMath
  module Vector
    module ClassMethods
      def [](*array)
        new(*array)
      end

      def zero
        new(*([0.0] * size))
      end
    end

    def self.included(base)
      base.define_singleton_method(:size, ->() { base.const_get(:SIZE) })
      base.extend ClassMethods
      base.const_set(:Zero, base.zero.freeze)
    end

    def initialize(*args)
      raise ArgumentError, "wrong number of arguments (#{args.size} for #{size})" if args.size != size
      raise ArgumentError, "It's not numeric" unless args.all? { |e| Numeric === e }
      @v = args
    end

    %w'+ -'.each do |sign|
      define_method(sign, ->(v) do
        raise ArgumentError, "no implicit conversion of #{v.class} into #{self.class}" unless self.class === v
        v = v.instance_variable_get(:@v)
        self.class.new(*@v.zip(v).map! { |a, b| a.send(sign, b) })
      end)
    end

    def -@
      self.class.new(*@v.map(&:-@))
    end

    def /(v)
      case v
        when Numeric
          self.class.new *@v.map{ |e| e / v }
        else
          raise ArgumentError, "Operation '/' not valid for #{v.class}"
      end
    end

    def ==(other)
      return false unless self.class === other
      @v == other.instance_variable_get(:@v)
    end

    def [](i)
      @v[i]
    end

    def angle(other)
      raise ArgumentError, "no implicit conversion of #{v.class} into #{self.class}" unless self.class === other
      Math.acos(dot(other) / Math.sqrt(square_norm * other.square_norm))
    end

    def coerce(v)
      case v
        when Numeric then return Scalar.new(v), self
        else raise TypeError, "#{self.class} can't be coerced into #{v.class}"
      end
    end

    def collect(&block)
      return to_enum(__method__) unless block_given?
      self.class.new(*@v.collect(&block))
    end

    def dup
      self.class.new(*@v)
    end

    def each(&block)
      return to_enum(__method__) unless block_given?
      @v.each(&block)
      self
    end

    def eql?(other)
      return false unless self.class === other
      @v.eql? other.instance_variable_get(:@v)
    end

    def freeze
      @v.freeze
      super
    end

    def inner_product(v)
      raise ArgumentError, "no implicit conversion of #{v.class} into #{self.class}" unless self.class === v
      v = v.instance_variable_get(:@v)
      @v.zip(v).map! { |a, b| a * b }.reduce(&:+)
    end

    def magnitude
      Math.sqrt(inner_product(self))
    end

    def normalize
      self / magnitude
    end

    def normalize!
      mag = magnitude
      @v.map! { |e| e / mag }
      self
    end

    def size
      self.class.size
    end

    def square_magnitude
      dot(self)
    end

    def zero?
      @v.all?(&:zero?)
    end

    %w'x y'.each_with_index do |s, i|
      define_method s, ->(){ @v[i] }
      define_method "#{s}=", ->(v){ @v[i] = v }
    end

    def to_a
      @v.dup
    end

    def to_s(notation = nil)
      case notation
        when nil        then inspect
        when :row       then "[#{@v.join("\t")}]"
        when :column    then @v.join("\n")
        when :cartesian then "(#{@v.join(", ")})"
      end
    end

    def inspect
      "Vector#{size}#{@v.inspect}"
    end

    alias_method :dot,           :inner_product
    alias_method :r,             :magnitude
    alias_method :length,        :magnitude
    alias_method :norm,          :magnitude
    alias_method :map,           :collect
    alias_method :square_length, :square_magnitude
    alias_method :square_norm,   :square_magnitude
    # alias_method :to_ary,        :to_a
  end
end
