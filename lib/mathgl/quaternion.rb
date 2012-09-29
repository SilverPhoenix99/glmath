module MathGL
  class Quaternion
    def self.from_angle_axis(angle, axis)
      angle = angle/2
      n = axis.normalize
      sa = sin(angle)
      new(cos(angle), sa * n.x, sa * n.y, sa * n.z)
    end

    def self.[](w, x, y, z)
      new(w, x, y, z)
    end

    def initialize(w, x, y, z)
      @q = w, x, y, z
      raise ArgumentError, "Must be Numeric" unless @q.all? { |e| e.is_a? Numeric}
    end

    def +(v)
      case v
      when Numeric
        self.class.new(v + w, x, y, z)
      when Quaternion
        self.class.new(q + v.w, x + v.x, y + v.y, z + v.z)
      else
        v + self
      end
    end

    def - q
      self + -q
    end

    def *(v)
      case v
      when Numeric
        self.class.new(q * v, x * v, y * v, z * v)
      when Quaternion
        cross_product(v)
      end
    end

    def /(v)
      case v
      when Numeric
        @q.map { |i| i/v}
      when Quaternion
        self * v.inverse
      end
    end

    def -@
      self.class.new(*@q.map(&:-@))
    end

    def ==(other)
      return false unless self.class === other
      @q == other.instance_variable_get(:@q)
    end

    %w'w x y z'.each_with_index do |m, i|
      define_method m, ->(){ @q[i] }
      define_method "#{m}=", ->(v){ @q[i] = v }
    end

    def coerce(v)
      case v
      when Numeric
        return Scalar.new(v), self
      else raise TypeError, "#{self.class} can't be coerced into #{v.class}"
      end
    end

    def conjugate
      self.class.new(w, -x, -y, -z)
    end

    def conjugate!
      @q = w, -x, -y, -z
    end

    def cross_product(q)
      self.class.new(
        w * q.w - x * q.x - y * q.y - z * q.z,
        w * q.x + x * q.w + z * q.y + y * q.z,
        w * q.y + y * q.w + x * q.z + z * q.x,
        w * q.z + z * q.w + y * q.x + x * q.y)
    end

    def difference(q)
      q * inverse
    end

    def dot_product(q)
      w * q.w + x * q.x + y * q.y + z * q.z
    end

    def inverse
      conjugate / norm
    end

    def inspect
      "Quaternion(#{w}, #{x}, #{y}, #{z})"
    end

    def imaginary
      [x, y, z]
    end

    def log
      alpha = acos(w)
      s = alpha / sin(alpha)
      self.class.new(0, *imag.map{ |i| i * s })
    end

    def normalize
      self/norm
    end

    def normalize!
      i = 1.0/norm
      @q.map! { |e| e * i }
      self
    end

    def norm
      Math.sqrt(squared_norm)
    end

    def squared_norm
      w * w + x * x + y * y + z * z
    end

    def real
      w
    end

    def slerp

    end

    def to_a
      @q.dup
    end

    def to_euler
      EulerAngle.new(a,b,c)
    end

    def to_s(notation = nil)
      case notation
      when :scalar_vector
        "(#{w}, [#{x}, #{y}, #{z}])"
      when :vertical
        "#{w}\n#{x}\n#{y}\n#{z}"
      else
        "(#{w}, #{x}, #{y}, #{z})"
      end

    end

    def to_matrix
      xx = 2 * x * x
      yy = 2 * y * y
      zz = 2 * z * z
      xy = 2 * x * y
      wz = 2 * w * z
      xz = 2 * x * z
      wy = 2 * w * y
      yz = 2 * y * z
      wx = 2 * w * x

      Matrix4[1 - yy - zz, xy - wz, xz + wy, 0,
              xy + wz, 1 - xx - zz,  yz - wx, 0,
              xz - wy, yz + wx, 1 - xx - yy, 0,
              0, 0, 0, 1]
    end

    alias_method :conj,  :conjugate
    alias_method :conj!, :conjugate
    alias_method :cross, :cross_product
    alias_method :dot,   :dot_product
    alias_method :im,    :imaginary
    alias_method :imag,  :imaginary
    alias_method :inv,   :inverse
    alias_method :re,    :real
  end
end