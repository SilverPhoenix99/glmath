module GLMath
  class Matrix2

    DIMENSION = 2
    LENGTH    = 4

    #conter-clockwise rotation
    def self.rotation(theta, homogenous = false)
      s, c = Math.sin(theta), Math.cos(theta)
      m = new(c, -s, s, c)
      homogenous ? m.expand : m
    end

    def self.scale(x, y, homogenous = false)
      m = diagonal(x, y)
      homogenous ? m.expand : m
    end

    include Matrix

    def *(v)
      case v
      when Vector2
        v.class.new(@m[0] * v.x + @m[1] * v.y, @m[2] * v.x + @m[3] * v.y)
      when Matrix2
        m = v.instance_variable_get(:@m)
        self.class.new(@m[0]*m[0] + @m[1]*m[2], @m[0]*m[1] + @m[1]*m[3],
                       @m[2]*m[0] + @m[3]*m[2], @m[2]*m[1] + @m[3]*m[3])
      when Numeric
        super
      else
        raise ArgumentError
      end
    end

    def adjugate!
      @m = [ @m[3], -@m[1],
            -@m[2],  @m[0]]
      self
    end

    def determinant
      @m[0] * @m[3] - @m[1] * @m[2]
    end

    def expand
      Matrix3.new(@m[0], @m[1], 0.0,
                  @m[2], @m[3], 0.0,
                  0.0,   0.0,   1.0)
    end

    def inverse
      d = determinant
      raise ArgumentError, 'Determinant is zero' if d.zero?
      adjugate * (1.0 / d)
    end

    def lup
      raise ArgumentError, "Determinant is zero" if singular?

      if @m[0].abs > @m[1].abs
        a, b, c, d = 0, 1, 2, 3
        p = self.class.new(1.0, 0.0, 0.0, 1.0)
      else
        a, b, c, d = 2, 3, 0, 1
        p = self.class.new(0.0, 1.0, 1.0, 0.0)
      end

      l = self.class.new(1.0, 0.0, @m[c] / @m[a], 1.0)
      u = self.class.new(@m[a], @m[b], 0.0, @m[d] - @m[b]*@m[c] / @m[a])
      [l, u, p]
    end

    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup

  end
end