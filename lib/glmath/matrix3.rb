module GLMath
  class Matrix3

    class << self
      def dimension
        3
      end

      def rotation(angle, axis, homogenous = false)
        n = axis.normalize
        ct = Math.cos(angle)
        st = Math.sin(angle)
        ct1 = 1 - ct
        xy = n.x * n.y * ct1
        xz = n.x * n.z * ct1
        yz = n.y * n.z * ct1

        m = new(n.x*n.x*ct1 + ct, xy + n.z * st,    xz - n.y * st,
                xy - n.z * st,    n.y*n.y*ct1 + ct, yz + n.x * st,
                xz + n.y * st,    yz - n.x * st,    n.z*n.z*ct1 + ct)
        homogenous ? m.expand : m
      end

      def scale(x, y, z, homogenous = false)
        m = diagonal(x, y, z)
        homogenous ? m.expand : m
      end

      def translation(x, y)
        Matrix3.new(1.0, 0.0, 0.0,
                    0.0, 1.0, 0.0,
                    x,   y,   1.0)
      end
    end

    include Matrix

    def *(v)
      case v
        when Vector3
          v.class.new(@m[0] * v.x + @m[1] * v.y + @m[2] * v.z,
                      @m[3] * v.x + @m[4] * v.y + @m[5] * v.z,
                      @m[6] * v.x + @m[7] * v.y + @m[8] * v.z)
        when Matrix3
          m = v.instance_variable_get(:@m)
          self.class.new(
            @m[0]*m[0]+@m[1]*m[3]+@m[2]*m[6], @m[0]*m[1]+@m[1]*m[4]+@m[2]*m[7], @m[0]*m[2] + @m[1]*m[5] + @m[2]*m[8],
            @m[3]*m[0]+@m[4]*m[3]+@m[5]*m[6], @m[3]*m[1]+@m[4]*m[4]+@m[5]*m[7], @m[3]*m[2] + @m[4]*m[5] + @m[5]*m[8],
            @m[6]*m[0]+@m[7]*m[3]+@m[8]*m[6], @m[6]*m[1]+@m[7]*m[4]+@m[8]*m[7], @m[6]*m[2] + @m[7]*m[5] + @m[8]*m[8])
        else
          super
      end
    end

    def adjugate!
      @m =[@m[4] * @m[8] - @m[5] * @m[7],
           @m[5] * @m[6] - @m[3] * @m[8],
           @m[3] * @m[7] - @m[4] * @m[6],
           @m[2] * @m[7] - @m[1] * @m[8],
           @m[0] * @m[8] - @m[2] * @m[6],
           @m[1] * @m[6] - @m[0] * @m[7],
           @m[1] * @m[5] - @m[2] * @m[4],
           @m[2] * @m[3] - @m[0] * @m[5],
           @m[0] * @m[4] - @m[1] * @m[3]]
      self
    end

    def determinant
      @m[0] * ( @m[4] * @m[8] - @m[5] * @m[7] ) +
      @m[1] * ( @m[5] * @m[6] - @m[3] * @m[8] ) +
      @m[2] * ( @m[3] * @m[7] - @m[4] * @m[6] )
    end

    def expand
      Matrix4.new(@m[0], @m[1], @m[2], 0.0,
                  @m[3], @m[4], @m[5], 0.0,
                  @m[6], @m[7], @m[8], 0.0,
                  0.0,   0.0,   0.0,   1.0)
    end

    alias_method :det, :determinant

  end
end