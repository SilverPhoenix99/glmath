module MathGL
  class Matrix2

    class << self
      def dimension
        2
      end

      #conter-clockwise rotation
      def rotation(theta, homogenous = false)
        s, c = Math.sin(theta), Math.cos(theta)
        m = new(c, -s, s, c)
        homogenous ? m.expand : m
      end

      def scale(x, y, homogenous = false)
        m = diagonal(x, y)
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
      m = @m.dup
      m[2,  0] = 0.0
      m.push(0.0, 0.0, 0.0, 1.0)
      Matrix3.new(*m)
    end

    def lup
      if @m[0].abs > @m[1].abs
        a, b, c, d = 0, 1, 2, 3
        p = self.class.new(1.0, 0.0, 0.0, 1.0)
      else
        a, b, c, d = 1, 0, 3, 2
        p = self.class.new(0.0, 1.0, 1.0, 0.0)
      end
      l = self.class.new(1.0, @m[b].quo(@m[a]), 0, 1.0)
      u = self.class.new(@m[a], 0.0, @m[c], @m[d] - @m[b]*@m[c].quo(@m[a]))
      [l, u, p]
    end

    def permutation?
      n = @m.each_slice(dim).to_a
      n.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v } &&
        n.transpose.map { |c| c.select(&:zero?).count == 1 && c.select { |v| v == 1 }.count == 1 }.all? { |v| v }
    end

    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup

  end
end