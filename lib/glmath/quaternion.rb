module GLMath
  class Quaternion
    class << self
      def [](*args)
        new(*args)
      end

      def from_angle_axis(angle, axis)
        angle = angle/2.0
        n = axis.normalize
        sa = Math.sin(angle)
        new(Math.cos(angle), sa * n.x, sa * n.y, sa * n.z)
      end

      def identity
        new(1.0, 0.0, 0.0, 0.0)
      end

      def slerp(q0, q1, t)
        (q1*q0.inverse).power(t)*q0
      end

      alias_method :I, :identity
    end

    def initialize(w, x, y, z)
      @q = w, x, y, z
      raise ArgumentError, 'argumnents must be Numeric' unless @q.all? { |e| e.is_a?(Numeric) }
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

    def -(q)
      self + (-q)
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
          self.class.new(*@q.map { |i| i/v})
        when Quaternion
          self * v.inverse
      end
    end

    def -@
      self.class.new(*@q.map(&:-@))
    end

    def ==(other)
      self.class === other && @q == other.instance_variable_get(:@q)
    end

    %w'w x y z'.each_with_index do |m, i|
      define_method m, ->() { @q[i] }
      define_method "#{m}=", ->(v) { @q[i] = v }
    end

    def coerce(v)
      case v
        when Numeric then return Scalar.new(v), self
        else raise TypeError, "#{self.class} can't be coerced into #{v.class}"
      end
    end

    def conjugate
      self.class.new(w, -x, -y, -z)
    end

    def conjugate!
      @q = w, -x, -y, -z
      self
    end

    #Warning: standard notation.
    def cross_product(q)
      self.class.new(
        w * q.w - x * q.x - y * q.y - z * q.z,
        w * q.x + x * q.w + y * q.z - z * q.y,
        w * q.y + y * q.w + z * q.x - x * q.z,
        w * q.z + z * q.w + x * q.y - y * q.x)
    end

    def difference(q)
      q * inverse
    end

    def dot_product(q)
      w * q.w + x * q.x + y * q.y + z * q.z
    end

    def dup
      self.class.new(*@q)
    end

    def exp
      a = Math.sqrt(x*x + y*y + z*z)
      ew = Math.exp(w)
      s = ew * Math.sin(a) / a
      self.class.new(ew * Math.cos(a), x * s, y * s, z * s)
    end

    def imaginary
      [x, y, z]
    end

    def inspect
      "Quaternion[#{w}, #{x}, #{y}, #{z}]"
    end

    def inverse
      conjugate / norm
    end

    def log
      nv = x*x + y*y + z*z
      nq = Math.sqrt(w*w + nv)
      s = Math.acos(w/nq) / Math.sqrt(nv)
      self.class.new(Math.log(nq), x * s, y * s, z * s)
    end

    def norm
      Math.sqrt(squared_norm)
    end

    def normalize
      self / norm
    end

    def normalize!
      i = 1.0 / norm
      @q.map! { |e| e * i }
      self
    end

    def power(p)
      (log*p).exp
    end

    def real
      w
    end

    def rotate(v3)
      Vector3[*(self * Quaternion[0.0, *v3] * inverse).to_a[1..-1]]
    end

    def squared_norm
      w * w + x * x + y * y + z * z
    end

    def to_a
      @q.dup
    end

    def to_s(notation = nil)
      case notation
        when :scalar_vector
          "(#{w}, [#{x}, #{y}, #{z}])"
        when :vertical
          "#{w}\n#{x}\n#{y}\n#{z}"
        else
          "Quaternion[#{w}, #{x}, #{y}, #{z}]"
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