module MathGL
  module Vector
    module ClassMethods

      def [](*array)
        new(*array)
      end

      def zero
        new(*([0] * size))
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    %w'+ -'.each do |s|
      define_method(s, ->(v) do
        v = v.instance_variable_get(:@v)
        self.class.new(*[@v, v].transpose.map!{ |a, b| a.send(s, b) })
      end)
    end

    def -@
      self.class.new *@v.map(&:-@)
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

    def coerce(v)
      case v
      when Numeric
        return Scalar.new(v), self
      else raise TypeError, "#{self.class} can't be coerced into #{v.class}"
      end
    end

    def collect(&block)
      return to_enum(:collect) unless block_given?
      self.class.new(*@v.collect(&block))
    end

    def each(&block)
      return to_enum(:each) unless block_given?
      @v.each(&block)
      self
    end

    def eql?(other)
      return false unless self.class === other
      @v.eql? other.instance_variable_get(:@v)
    end

    def hash
      @v.hash
    end

    def inner_product(v)
      raise ArgumentError unless self.class === v
      v = v.instance_variable_get(:@v)
      [@v, v].transpose.map!{ |a, b| a * b }.reduce(&:+)
    end

    def magnitude
      Math.sqrt(inner_product(self))
    end

    def normalize
      n = magnitude
      self / n
    end

    def normalize!
      n = magnitude
      @v.map!{ |e| e/n }
      self
    end

    %w'x y'.each_with_index do |s, i|
      define_method s, ->(){ @v[i] }
      define_method "#{s}=", ->(v){ @v[i] = v }
    end

    def to_a
      @v.dup
    end

    def to_ary
      to_a
    end

    def to_s(notation = nil)
      case notation
      when nil        then "Vector#{size}#{@v}"
      when :row       then "[#{@v.join("\t")}]"
      when :column    then @v.join("\n")
      when :cartesian then "(#{@v.join(", ")})"
      end
    end

    def inspect
      "Vector#{size}#{@v.inspect}"
    end

    alias_method :dot,    :inner_product
    alias_method :r,      :magnitude
    alias_method :length, :magnitude
    alias_method :norm,   :magnitude
    alias_method :map,    :collect
  end
end
