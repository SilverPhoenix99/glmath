module GLMath
  module Matrix
    module ClassMethods
      def [](*rows)
        new(*rows)
      end

      def build
        new(*dim.times.flat_map { |r| dim.times.map { |c| yield r, c } })
      end

      def columns(*args)
        raise ArgumentError, "wrong number of arguments #{args.length} for #{dim}" unless args.length == dim
        raise ArgumentError, "wrong array size. All arrays must have size #{dim}" unless args.all? { |arg| arg.length == dim }
        new(*args.transpose.flatten(1))
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
        raise ArgumentError, "wrong number of arguments #{args.length} for #{dim}" unless args.length == dim
        raise ArgumentError, "wrong array size. All arrays must have size #{dim}" unless args.all? { |arg| arg.length == dim }
        new(*args.flatten(1))
      end

      def scalar(n)
        build { |r, c| r == c ? n : 0.0 }
      end

      def zero
        new(*[0.0] * (dim * dim))
      end

      alias_method :i,    :identity
      alias_method :unit, :identity
    end

    def self.included(base)
      base.define_singleton_method(:length, ->() { base.const_get(:LENGTH) })
      base.define_singleton_method(:dimension, ->() { base.const_get(:DIMENSION) })
      base.extend ClassMethods
      base.const_set(:Identity,  base.identity.freeze)
      base.const_set(:I,    base.const_get(:Identity))
      base.const_set(:Unit, base.const_get(:Identity))
    end

    def initialize(*args)
      raise ArgumentError, "wrong number of arguments (#{args.length} for #{dim * dim})" unless args.length == dim * dim
      raise ArgumentError, "It's not numeric" unless args.all? { |e| Numeric === e }
      @m = args
    end

    %w'+ -'.each do |s|
      define_method(s, ->(m) do
        raise ArgumentError unless self.class === m
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
          # transpose(A) = A'.
          # A / B = X (=) A = XB (=) B'X' = A'
          other.transpose.solve(self.transpose).transpose
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
      conjugate!
      transpose!
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
      raise ArgumentError, "can only be an Integer between 0 and #{dim - 1}:#{c}" unless c.is_a?(Integer) && (0...dim).include?(c)
      dim.times.map { |r| @m[r * dim + c] }
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
      self.class.new(*@m)
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
      self.class.new(*@m)
    end

    def each(which = :all)
      return to_enum :each, which unless block_given?
      case which
        when :all
          @m.each { |e| yield e }
        when :diagonal
          dim.times.each { |r| yield self[r, r] }
        when :off_diagonal
          dim.times.each { |r| dim.times.each { |c| yield self[r, c] unless r == c } }
        when :lower
          dim.times.each { |r| dim.times.each { |c| yield self[r, c] if r >= c } }
        when :strict_lower
          dim.times.each { |r| dim.times.each { |c| yield self[r, c] if r > c } }
        when :strict_upper
          dim.times.each { |r| dim.times.each { |c| yield self[r, c] if r < c } }
        when :upper
          dim.times.each { |r| dim.times.each { |c| yield self[r, c] if r <= c } }
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
          dim.times.each { |r| yield self[r, r], r, r }
        when :off_diagonal
          dim.times.each { |r| dim.times.each { |c| yield self[r, c], r, c unless r == c } }
        when :lower
          dim.times.each { |r| dim.times.each { |c| yield self[r, c], r, c if r >= c } }
        when :strict_lower
          dim.times.each { |r| dim.times.each { |c| yield self[r, c], r, c if r > c } }
        when :strict_upper
          dim.times.each { |r| dim.times.each { |c| yield self[r, c], r, c if r < c } }
        when :upper
          dim.times.each { |r| dim.times.each { |c| yield self[r, c], r, c if r <= c } }
        else
          raise ArgumentError, which
      end
      self
    end

    def eql?(other)
      other.is_a?(self.class) && @m.eql?(other.to_a)
    end

    def freeze
      @m.freeze
      super
    end

    def hermitian?
      transpose.conjugate! == self
    end

    def imaginary
      map(&:imaginary)
    end

    def inspect
      "Matrix#{dim}#{@m.inspect}"
    end

    def inverse
      # the inverse is solution to the equation AX = I
      solve(self.class.identity)
    end

    def length
      @m.length
    end

    def lower_triangular?
      each(:strict_upper).all?(&:zero?)
    end

    def lup
      raise ArgumentError, "Determinant is zero" if singular?

      # get pivot
      p = self.class.identity.rows
      rows = self.rows
      (dim - 1).times do |i|
        max, row = rows[i][i], i
        (i+1...dim).each { |j| max, row = rows[j][i], j if rows[j][i] > max }
        p[i], p[row] = p[row], p[i]
        rows[i], rows[row] = rows[row], rows[i]
      end
      p = self.class.new(*p.flatten(1))
      pivoted = self.class.new(*rows.flatten(1))

      # calculate L and U matrices
      l = self.class.identity
      u = self.class.zero

      dim.times.each do |i|
        dim.times.each do |j|
          if j >= i
            # upper
            u[i, j] = pivoted[i, j] - i.times.map { |k| u[k, j] * l[i, k] }.reduce(0.0, &:+)
          else
            # lower
            l[i, j] = (pivoted[i, j] - j.times.map { |k| u[k, j] * l[i, k] }.reduce(0.0, &:+)) / u[j, j]
          end
        end
      end

      [ l, u, p ]
    end

    def normal?
      n = transpose.conjugate!
      self * n == n * self
    end

    def permutation?
      rows.each do |r|
        return false unless r.select { |v| v.abs < 1e-14 }.count == dim - 1
        return false unless r.index { |v| (1.0 - v).abs < 1e-14 }
      end

      columns.each do |c|
        return false unless c.select { |v| v.abs < 1e-14 }.count == dim - 1
        return false unless c.index { |v| (1.0 - v).abs < 1e-14 }
      end

      true
    end

    def real
      map(&:real)
    end

    def real?
      @m.all?(&:real?)
    end

    def round(ndigits = 0)
      map { |e| e.round(ndigits) }
    end

    def row(r)
      raise ArgumentError, "can only be between 0 and #{dim}:#{r}" unless (0...dim).include? r
      @m[r * dim, dim]
    end

    def rows
      dim.times.map { |i| row(i) }
    end

    def scalar?
      diag = []
      each_with_index do |v, r, c|
        return false if r != c && !v.zero?
        diag << v if r == c
      end
      diag.uniq.size == 1
    end

    def singular?
      determinant.zero?
    end

    # Solves *AX = B*, where *A* is `self` and *B* is the argument
    def solve(matrix)
      raise ArgumentError, "expected class #{ self.class }, but got #{ matrix.class }" unless self.class === matrix

      l, u, p = lup

      # Ax = b (=) LUx = b (=) Ly = b && Ux = y
      # If y is defined to be Ux: Ly = b
      y = self.class.zero
      matrix = p * matrix
      # Forward solve Ly = b
      dim.times do |c|
        dim.times do |r|
          y[r, c] = matrix[r, c]
          (0...r).each { |j| y[r, c] -= l[r, j] * y[j, c] }
          y[r, c] /= l[r, r]
        end
      end

      # Backward solve Ux = y
      x = self.class.zero

      dim.times do |c|
        (dim - 1).downto(0) do |i|
          x[i, c] = y[i, c]
          (i+1...dim).each { |j| x[i, c] -= u[i, j] * x[j, c] }
          x[i, c] /= u[i, i]
        end
      end

      x
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
        else raise ArgumentError, "unknown notation #{notation.inspect}"
      end
    end

    def trace
      diagonal.reduce(&:+)
    end

    def transpose
      clone.transpose!
    end

    def transpose!
      @m = @m.each_slice(dim).to_a.transpose.flatten!(1)
      self
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
    alias_method :lup_decomposition, :lup
    alias_method :map,               :collect
    alias_method :t,                 :transpose
    alias_method :t!,                :transpose!
    alias_method :tr,                :trace
  end
end