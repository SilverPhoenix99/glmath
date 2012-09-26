#encoding: UTF-8
module MathGL
  class Matrix4

    class << self
      def dimension
        4
      end

      alias_method :dim,  :dimension
    end

    include Matrix

    def *(v)
      #TODO
      case v
      when Numeric
        self.class.new(*@m.map { |e| e * v } )
      when Vector4
        v.class.new(
          @m[0] * v.x + @m[4] * v.y + @m[8]  * v.z + @m[12] * v.w,
          @m[1] * v.x + @m[5] * v.y + @m[9]  * v.z + @m[13] * v.w,
          @m[2] * v.x + @m[6] * v.y + @m[10] * v.z + @m[14] * v.w,
          @m[3] * v.x + @m[7] * v.y + @m[11] * v.z + @m[15] * v.w
        )
      when Matrix4
        self.class.columns(self*v.column(0), self*v.column(1), self*v.column(2), self*v.column(3))
      end
    end

    def adjoint
      a =  @m[4] *  @m[9] -  @m[5] *  @m[8]
      b =  @m[4] * @m[10] -  @m[6] *  @m[8]
      c =  @m[4] * @m[11] -  @m[7] *  @m[8]
      d =  @m[4] * @m[13] -  @m[5] * @m[12]
      f =  @m[4] * @m[14] -  @m[6] * @m[12]
      g =  @m[4] * @m[15] -  @m[7] * @m[12]
      h =  @m[5] * @m[10] -  @m[6] *  @m[9]
      i =  @m[5] * @m[11] -  @m[7] *  @m[9]
      j =  @m[5] * @m[14] -  @m[6] * @m[13]
      k =  @m[5] * @m[15] -  @m[7] * @m[13]
      l =  @m[6] * @m[11] -  @m[7] * @m[10]
      m =  @m[6] * @m[15] -  @m[7] * @m[14]
      n =  @m[8] * @m[13] -  @m[9] * @m[12]
      o =  @m[8] * @m[14] - @m[10] * @m[12]
      p =  @m[8] * @m[15] - @m[11] * @m[12]
      q =  @m[9] * @m[14] - @m[10] * @m[13]
      r =  @m[9] * @m[15] - @m[11] * @m[13]
      s = @m[10] * @m[15] - @m[11] * @m[14]

      self.class.new(+ @m[5] * s - @m[6] * r + @m[7] * q,
                     - @m[4] * s + @m[6] * p - @m[7] * o,
                     + @m[4] * r - @m[5] * p + @m[7] * n,
                     - @m[4] * q + @m[5] * o - @m[6] * n,
                     - @m[1] * s + @m[2] * r - @m[3] * q,
                     + @m[0] * s - @m[2] * p + @m[3] * o,
                     - @m[0] * r + @m[1] * p - @m[3] * n,
                     + @m[0] * q - @m[1] * o + @m[2] * n,
                     + @m[1] * m - @m[2] * k + @m[3] * j,
                     - @m[0] * m + @m[2] * g - @m[3] * f,
                     + @m[0] * k - @m[1] * g + @m[3] * d,
                     - @m[0] * j + @m[1] * f - @m[2] * d,
                     - @m[1] * l + @m[2] * i - @m[3] * h,
                     + @m[0] * l - @m[2] * c + @m[3] * b,
                     - @m[0] * i + @m[1] * c - @m[3] * a,
                     + @m[0] * h - @m[1] * b + @m[2] * a).transpose!
    end

    def determinant
      a = @m[10] * @m[15] - @m[11] * @m[14]
      b = @m[11] * @m[13] - @m[9]  * @m[15]
      c = @m[9]  * @m[14] - @m[10] * @m[13]
      d = @m[8]  * @m[15] - @m[11] * @m[12]
      e = @m[10] * @m[12] - @m[8]  * @m[14]
      f = @m[8]  * @m[13] - @m[9]  * @m[12]

      @m[0] * ( @m[5] * a + @m[6] * b + @m[7] * c) +
        @m[1] * (-@m[4] * a + @m[6] * d + @m[7] * e) +
        @m[2] * (-@m[4] * b - @m[5] * d + @m[7] * f) +
        @m[3] * (-@m[4] * c - @m[5] * e - @m[6] * f)
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
      case notation
      when nil
        "Matrix4#{@m}"
      when :matrix
        "#{self[0]}\t#{self[4]}\t#{self[8]}\t#{self[12]}\n#{self[1]}\t#{self[5]}\t#{self[9]}\t#{self[13]}\n#{self[2]}\t#{self[6]}\t#{self[10]}\t#{self[14]}\n#{self[3]}\t#{self[7]}\t#{self[11]}\t#{self[15]}"
      end
    end

    alias_method :det,               :determinant
    alias_method :dim,               :dimension
    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup
  end
end