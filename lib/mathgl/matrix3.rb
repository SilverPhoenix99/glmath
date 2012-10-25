module MathGL
  class Matrix3

    class << self
      def dimension
        3
      end

      alias_method :dim,  :dimension
    end

    include Matrix

    def *(v)
      case v
      when Numeric
        self.class.new(*@m.map { |e| e * v } )
      when Vector3
        v.class.new(@m[0] * v.x + @m[3] * v.y + @m[6] * v.z,
                    @m[1] * v.x + @m[4] * v.y + @m[7] * v.z,
                    @m[2] * v.x + @m[5] * v.y + @m[8] * v.z)
      when Matrix3
        self.class.columns(self*v.column(0), self*v.column(1), self*v.column(2))
      end
    end

    def adjoint
      self.class.new(@m[4] * @m[8] - @m[5] * @m[7],
                     @m[5] * @m[6] - @m[3] * @m[8],
                     @m[3] * @m[7] - @m[4] * @m[6],
                     @m[2] * @m[7] - @m[1] * @m[8],
                     @m[0] * @m[8] - @m[2] * @m[6],
                     @m[1] * @m[6] - @m[0] * @m[7],
                     @m[1] * @m[5] - @m[2] * @m[4],
                     @m[2] * @m[3] - @m[0] * @m[5],
                     @m[0] * @m[4] - @m[1] * @m[3]).transpose!
    end

    def determinant
      @m[0] * (@m[4] * @m[8] - @m[5] * @m[7]) + @m[1] * (@m[5] * @m[6] - @m[3] * @m[8]) + @m[2] * (@m[3] * @m[7] - @m[4] * @m[6])
    end

    def expand
      Matrix4[@m[0..2] + [0.0] + @m[3..5] + [0.0] + @m[6..8] + [0.0, 0.0, 0.0, 0.0, 1.0]]
    end

    def lup
      #TODO
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
      #TODO
      n = @m.each_slice(dim).to_a
      n.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v } &&
        n.transpose.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v }
    end

    def to_s(notation = nil)
      #TODO
      case notation
      when nil     then "Matrix3#{@m}"
      when :matrix then "#{self[0]}\t#{self[3]}\t#{self[6]}\n#{self[1]}\t#{self[4]}\t#{self[7]}\n#{self[2]}\t#{self[5]}\t#{self[8]}"
      end
    end

    alias_method :det,               :determinant
    alias_method :dim,               :dimension
    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup
  end
end