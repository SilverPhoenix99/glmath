module GLMath
  class Vector

    def self.[](*array)
      new(*array)
    end

    def initialize(*args)
      raise ArgumentError, "It's not numeric" unless args.all? { |e| Numeric === e }
      @v = args
    end

    def +(v)
      v = v.to_a
      assert_size v.size
      self.class.new(*@v.zip(v).map! { |a, b| a + b })
    end

    def -(v)
      v = v.to_a
      assert_size v.size
      self.class.new(*@v.zip(v).map! { |a, b| a - b })
    end

    def +@
      self.class.new(*@v.map(&:+@))
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
      assert_index i
      @v[i]
    end

    def []=(i, value)
      raise ArgumentError, "It's not numeric" unless Numeric === value
      assert_index i
      @v[i] = value
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
      v = v.to_a
      assert_size v.size
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
      @v.size
    end

    def square_magnitude
      dot(self)
    end

    def zero?
      @v.all?(&:zero?)
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
      "#{self.class.lastname}#{@v.inspect}"
    end

    alias_method :dot,           :inner_product
    alias_method :r,             :magnitude
    alias_method :length,        :magnitude
    alias_method :norm,          :magnitude
    alias_method :map,           :collect
    alias_method :square_length, :square_magnitude
    alias_method :square_norm,   :square_magnitude

    private
    def assert_size(size)
      raise ArgumentError, "expected size #{self.size} but got #{size}" if size != self.size
    end

    def assert_index(i)
      raise ArgumentError, "expected index between 0 and #{self.size-1} but got #{i}" unless (0...self.size).include?(i)
    end
  end

  def self.Vector(components)
    components_size = components.size

    Class.new(Vector) do
      define_singleton_method :size, ->() { components_size }
      define_method :size, ->() { components_size }
      define_singleton_method :zero, ->() { new(*([0.0] * components_size)) }

      def initialize(*args)
        assert_size args.size
        super
      end

      components_regex = /^[#{components.join}]{2,}$/
      define_method :method_missing do |name, *args, &block|
        case name
          when components_regex
            raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 0)" unless args.size == 0
            values = name.to_s.each_char.to_a.map { |component| send(component) }
            type_name = "Vector#{values.size}"
            type = GLMath.const_defined?(type_name) ? GLMath.const_get(type_name) : Vector
            type.new(*values)
          else
            super(name, *args, &block)
        end
      end

      components.each_with_index do |component, i|
        define_method component, ->() { self[i] }
        define_method "#{component}=", ->(value) { self[i] = value }

        init_vector = components.map { 0.0 }.tap { |v| v[i] = 1.0 }
        define_singleton_method component, ->() { new(*init_vector) }
      end
    end
  end
end
