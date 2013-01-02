module MathGL
  class Matrix4

    class << self
      def dimension
        4
      end

      def ortho(left, right, bottom, top, near, far)
        rl = right - left
        tb = top - bottom
        fn = far - near

        new(2.0/rl,              0.0,                0.0,                 0.0,
            0.0,                 2.0/tb,             0.0,                 0.0,
            0.0,                 0.0,               -2.0/fn,              0.0,
            -(right + left)/rl, -(top + bottom)/tb, -(far + near)/fn,     1.0)
      end

      def perspective(fovy, aspect, near, far)
        t  = 1.0 / tan(fovy * 0.5)
        fn = 1.0 / (far - near)
        new(t/aspect, 0.0, 0.0,             0.0,
            0.0,      t,   0.0,             0.0,
            0.0 ,     0.0, (far + near)*fn, 1.0,
            0.0,      0.0, 2.0*far*near*fn, 0.0)
      end

      def rotation(angle, axis)
        Matrix3.rotation(angle, axis, true)
      end

      def scale(x, y, z, w = 1.0)
        diagonal(x, y, z, w)
      end

      def translation(x, y, z)
        Matrix3.translation(x, y, z)
      end
    end

    include Matrix

    def *(v)
      case v
      when Vector4
        v.class.new(
          @m[ 0] * v.x + @m[ 1] * v.y + @m[ 2] * v.z + @m[ 3] * v.w,
          @m[ 4] * v.x + @m[ 5] * v.y + @m[ 6] * v.z + @m[ 7] * v.w,
          @m[ 8] * v.x + @m[ 9] * v.y + @m[10] * v.z + @m[11] * v.w,
          @m[12] * v.x + @m[13] * v.y + @m[14] * v.z + @m[15] * v.w)
        when Matrix4
          m = v.instance_variable_get(:@m)
          self.class.new(
            @m[ 0] * m[0] + @m[ 1] * m[4] + @m[ 2] * m[ 8] + @m[ 3] * m[12],
            @m[ 0] * m[1] + @m[ 1] * m[5] + @m[ 2] * m[ 9] + @m[ 3] * m[13],
            @m[ 0] * m[2] + @m[ 1] * m[6] + @m[ 2] * m[10] + @m[ 3] * m[14],
            @m[ 0] * m[3] + @m[ 1] * m[7] + @m[ 2] * m[11] + @m[ 3] * m[15],
            @m[ 4] * m[0] + @m[ 5] * m[4] + @m[ 6] * m[ 8] + @m[ 7] * m[12],
            @m[ 4] * m[1] + @m[ 5] * m[5] + @m[ 6] * m[ 9] + @m[ 7] * m[13],
            @m[ 4] * m[2] + @m[ 5] * m[6] + @m[ 6] * m[10] + @m[ 7] * m[14],
            @m[ 4] * m[3] + @m[ 5] * m[7] + @m[ 6] * m[11] + @m[ 7] * m[15],
            @m[ 8] * m[0] + @m[ 9] * m[4] + @m[10] * m[ 8] + @m[11] * m[12],
            @m[ 8] * m[1] + @m[ 9] * m[5] + @m[10] * m[ 9] + @m[11] * m[13],
            @m[ 8] * m[2] + @m[ 9] * m[6] + @m[10] * m[10] + @m[11] * m[14],
            @m[ 8] * m[3] + @m[ 9] * m[7] + @m[10] * m[11] + @m[11] * m[15],
            @m[12] * m[0] + @m[13] * m[4] + @m[14] * m[ 8] + @m[15] * m[12],
            @m[12] * m[1] + @m[13] * m[5] + @m[14] * m[ 9] + @m[15] * m[13],
            @m[12] * m[2] + @m[13] * m[6] + @m[14] * m[10] + @m[15] * m[14],
            @m[12] * m[3] + @m[13] * m[7] + @m[14] * m[11] + @m[15] * m[15])
      else
        super
      end
    end

    def adjoint!
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

      @m = [+ @m[5] * s - @m[6] * r + @m[7] * q,
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
            + @m[0] * h - @m[1] * b + @m[2] * a]
      self
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
    end

    def permutation?
      #TODO
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
    alias_method :lup_decomposition, :lup
  end
end