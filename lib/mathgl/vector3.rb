module MathGL
  class Vector3

    class << self
      def size
        3
      end
    end

    include Vector

    def initialize(x, y, z)
      @v = [x, y, z]
      raise ArgumentError, "It's not numeric" unless @v.all? { |e| Numeric === e }
    end

    def *(v)
      case v
      when Numeric
        self.class.new(*@v.map{ |e| e * v })
      when Vector3
        raise ArgumentError, "Operation '*' not valid for Vector3"
      when Matrix3
        self.class.new(v[0] * x + v[3] * y + v[6] * z,
                       v[1] * x + v[4] * y + v[7] * z,
                       v[2] * x + v[5] * y + v[8] * z)
      end
    end

    def expand(w)
      Vector4.new(*(@v + [w]))
    end

    def outer_product(v)
      self.class.new(@v[1] * v.z - @v[2] * v.y, @v[0] * v.z - @v[2] * v.x, @v[0] * v.y - @v[1] * v.x)
    end

    def size
      3
    end

    def z
      @v[2]
    end

    def xy
      Vector2.new(*@v[0, 2])
    end

    def xz
      Vector2.new(@v[0], @v[2])
    end

    def yz
      Vector2.new(*@v[1, 2])
    end

    alias_method :cross_product, :outer_product
  end
end