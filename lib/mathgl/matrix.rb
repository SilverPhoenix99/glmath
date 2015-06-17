module MathGL
  module Matrix
    module ClassMethods
      def [](*rows)
        new(*rows)
      end

      def build
        new(dim.times.flat_map { |r| dim.times.map { |c| yield r, c } })
      end

      def columns(*args)
        new(*args.map(&:to_a).transpose.flatten!)
      end

      def diagonal(*args)
        raise ArgumentError, "wrong number of arguments (#{args.length} for #{dim})" if args.length != dim
        build { |r, c| r == c ? args[r] : 0.0 }
      end

      def dim
        dimension
      end

      def identity
        scalar(1.0)
      end

      def rows(*args)
        new(*args.map(&:to_a).flatten!)
      end

      def scalar(n)
        build { |r, c| r == c ? n : 0.0 }
      end

      def zero
        build { 0.0 }
      end

      alias_method :I,    :identity
      alias_method :unit, :identity
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize(*args)
      @m = case
             when args.length == 1 && args[0].length == dim * dim
               args[0].dup
             when args.length == dim * dim
               args
             else
               raise ArgumentError, "wrong number of arguments (#{args.length} for #{dim * dim})"
           end
      raise ArgumentError, "It's not numeric" unless @m.all? { |e| Numeric === e }
    end

    %w'+ -'.each do |s|
      define_method(s, ->(m) do
        m = m.instance_variable_get(:@m)
        self.class.new(*[@m, m].transpose.map { |a, b| a.send(s, b) })
      end)
    end

    def *(v)
      raise ArgumentError, v.class unless v.is_a?(Numeric)
      self.class.new(*@m.map { |e| e * v })
    end

    def /(other)
      case other
        when Numeric
          self.class.new(*@m.map { |v| v / other })
        when self.class
          self * other.inverse
        else
          raise ArgumentError, "Invalid type #{other.class}"
      end
    end

    def ==(other)
      other.is_a?(self.class) && @m == other.instance_variable_get(:@m)
    end

    def [](r, c = nil)
      @m[c ? r * dim + c : r]
    end

    def []= (r, c = nil, n)
      @m[c ? r * dim + c : r] = n
    end

    def adjoint
      clone.adjoint!
    end

    def adjoint!
      conjugate!.transpose!
    end

    def adjugate
      clone.adjugate!
    end

    def coerce(v)
      case v
        when Numeric then return Scalar.new(v), self
        else raise TypeError, "#{self.class} can't be coerced into #{v.class}"
      end
    end

    def collect(&block)
      block_given? ? self.class.new(*@m.collect(&block)) : to_enum(:collect)
    end

    def column(c)
      raise ArgumentError, "can only be between 0 and #{dim}:#{c}" unless (0...dim).include? c
      MathGL.const_get("Vector#{dim}", false).new(*dim.times.map { |r| @m[r * dim + c] })
    end

    def columns
      dim.times.map { |c| column(c) }
    end

    def conjugate
      clone.conjugate!
    end

    def conjugate!
      @m.map!(&:conjugate)
      self
    end

    def clone
      self.class.new(@m)
    end

    def diagonal
      dim.times.map { |r| self[r, r] }
    end

    def diagonal?
      each(:off_diagonal).all?(&:zero?)
    end

    def dimension
      self.class.dimension
    end

    def dup
      self.class.new(@m)
    end

    def each(which = :all)
      return to_enum :each, which unless block_given?
      case which
        when :all
          @m.each { |e| yield e }
        when :diagonal
          dim.times.each { |c| yield self[c, c] }
        when :off_diagonal
          dim.times.each { |c| dim.times.each { |r| yield self[c, r] unless c == r } }
        when :lower
          dim.times.each { |c| dim.times.each { |r| yield self[c, r] unless c <= r } }
        when :strict_lower
          dim.times.each { |c| dim.times.each { |r| yield self[c, r] unless c < r } }
        when :strict_upper
          dim.times.each { |c| dim.times.each { |r| yield self[c, r] unless c > r } }
        when :upper
          dim.times.each { |c| dim.times.each { |r| yield self[c, r] unless c >= r } }
        else
          raise ArgumentError, which
      end
      self
    end

    def each_with_index(which = :all)
      return to_enum :each_with_index, which unless block_given?
      case which
        when :all
          @m.each_with_index { |e, i| yield e, i / dim, i % dim }
        when :diagonal
          dim.times.each { |c| yield self[c, c], c, c }
        when :off_diagonal
          dim.times.each { |c| dim.times.each { |r| yield self[c, r], c, r unless c == r } }
        when :lower
          dim.times.each { |c| dim.times.each { |r| yield self[c, r], c, r unless c <= r } }
        when :strict_lower
          dim.times.each { |c| dim.times.each { |r| yield self[c, r], c, r unless c < r } }
        when :strict_upper
          dim.times.each { |c| dim.times.each { |r| yield self[c, r], c, r unless c > r } }
        when :upper
          dim.times.each { |c| dim.times.each { |r| yield self[c, r], c, r unless c >= r } }
        else
          raise ArgumentError, which
      end
      self
    end

    def eql?(other)
      other.is_a?(self.class) && @m.eql?(other.to_a)
    end

    def hash
      @m.hash
    end

    def hermitian?
      t.conj! == self
    end

    def imaginary
      map(&:imaginary)
    end

    def inspect
      "Matrix#{dim}#{@m.inspect}"
    end

    def inverse
      d = det
      raise ArgumentError, "Determinant is 0" if d == 0
      adjoint * (1.0/d)
    end

    def length
      @m.length
    end

    def lower_triangular?
      each(:strict_upper).all?(&:zero?)
    end

    def normal?
      n = t.conj!
      self * n == n * self
    end

    def orthogonal?
      self * t == self.class.I
    end

    def real
      map(&:real)
    end

    def real?
      all?(&:real?)
    end

    def round(ndigits = 0)
      map { |e| e.round(ndigits) }
    end

    def row(r)
      raise ArgumentError, "can only be between 0 and #{dim}:#{r}" unless (0...dim).include? r
      MathGL.const_get("Vector#{dim}", false).new(*@m[r * dim, dim])
    end

    def rows
      dim.times.map { |i| row(i) }
    end

    def singular?
      det == 0.0
    end

    def symmetric?
      each_with_index(:strict_upper).all? { |e, r, c| e == self[c, r] }
    end

    def to_a
      @m.dup
    end

    def to_s(notation = nil)
      case notation
        when nil     then "#{self.class.name.gsub(/^.*::/,'')}#{@m}"
        when :matrix then (dim*dim).times.each_slice(dim).map { |s| s.map { |i| self[i] }.join("\t") }.join("\n")
      end
    end

    def trace
      diagonal.reduce(&:+)
    end

    def transpose
      clone.transpose!
    end

    def transpose!
      @m = @m.each_slice(dim).to_a.transpose.flatten!
      self
    end

    def unitary?
      self * t.conj! == self.class.I
    end

    def upper_triangular?
      each(:strict_lower).all?(&:zero?)
    end

    def zero?
      @m.all?(&:zero?)
    end

    alias_method :component,         :[]
    alias_method :conj,              :conjugate
    alias_method :conj!,             :conjugate!
    alias_method :dim,               :dimension
    alias_method :element,           :[]
    alias_method :imag,              :imaginary
    alias_method :inv,               :inverse
    alias_method :map,               :collect
    alias_method :t,                 :transpose
    alias_method :t!,                :transpose!
    alias_method :tr,                :trace
  end
end