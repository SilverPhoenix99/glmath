module MathGL
  class Scalar

    def initialize(n)
      raise ArgumentError, 'Must be numeric' unless n.is_a?(Numeric)
      @n = n
    end

    def *(other)
      case other
        when Vector2, Vector3, Vector4, Matrix2, Matrix3, Matrix4
          other.map { |e| @n * e }
        else raise ArgumentError
      end
    end

    def /(other)
      case other
        when Matrix2, Matrix3, Matrix4
          self * other.inverse
        else raise ArgumentError
      end
    end
  end
end
