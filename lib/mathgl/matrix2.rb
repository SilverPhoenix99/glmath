module MathGL
  class Matrix2

    class << self
      def dimension
        2
      end

      alias_method :dim,  :dimension
    end

    include Matrix

    def *(v)
      case v
      when Numeric
        self.class.new(*@m.map { |e| e * v } )
      when Vector2
        v.class.new(@m[0] * v.x + @m[2] * v.y, @m[1] * v.x + @m[3] * v.y)
      when Matrix2
        self.class.columns(self*v.column(0), self*v.column(1))
      end
    end

    def adjoint
      self.class.new(@m[3], -@m[1], -@m[2], @m[0])
    end

    def determinant
      @m[0] * @m[3] - @m[1] * @m[2]
    end

    def lup
      if @m[0].abs > @m[1].abs
        a, b, c, d = 0, 1, 2, 3
        p = self.class[1.0, 0.0, 0.0, 1.0]
      else
        a, b, c, d = 1, 0, 3, 2
        p = self.class[0.0, 1.0, 1.0, 0.0]
      end
      l = self.class[1.0, @m[b].quo(@m[a]), 0, 1.0]
      u = self.class[@m[a], 0.0, @m[c], @m[d] - @m[b]*@m[c].quo(@m[a])]
      [l, u, p]
    end

    def permutation?
      n = @m.each_slice(dim).to_a
      n.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v } &&
        n.transpose.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v }
    end

    def to_s(notation = nil)
      case notation
      when nil     then "Matrix2#{@m}"
      when :matrix then "#{self[0]}\t#{self[2]}\n#{self[1]}\t#{self[3]}"
      end
    end

    alias_method :det,               :determinant
    alias_method :dim,               :dimension
    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup

  end
end