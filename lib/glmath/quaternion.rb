module GLMath
  class Quaternion
    def self.[](*args)
      new(*args)
    end

    def self.from_angle_axis(angle, axis)
      angle *= 0.5
      sa = Math.sin(angle)
      new(Math.cos(angle), sa * axis.x, sa * axis.y, sa * axis.z)
    end

    def self.identity
      new(1.0, 0.0, 0.0, 0.0)
    end

    def self.slerp(q0, q1, t)
      (q1 * q0.inverse).power(t) * q0
    end

    def initialize(w, x, y, z)
      @q = w, x, y, z
      raise ArgumentError, 'arguments must be Numeric' unless @q.all? { |e| e.is_a?(Numeric) }
    end

    I = identity.freeze

    def +(v)
      case v
        when Integer, Float, Rational
          self.class.new(v + w, x, y, z)
        when Quaternion
          self.class.new(w + v.w, x + v.x, y + v.y, z + v.z)
        else
          v + self
      end
    end

    def -(q)
      self + (-q)
    end

    def *(v)
      case v
        when Integer, Float, Rational
          self.class.new(w * v, x * v, y * v, z * v)
        when Quaternion
          cross_product(v)
      end
    end

    def /(v)
      case v
        when Integer, Float, Rational
          self.class.new(*@q.map { |i| i / v.to_f })
        when Quaternion
          self * v.inverse
      end
    end

    def -@
      self.class.new(*@q.map(&:-@))
    end

    def +@
      self.class.new(*@q.map(&:+@))
    end

    def ==(other)
      self.class === other && @q == other.instance_variable_get(:@q)
    end

    %w'w x y z'.each_with_index do |m, i|
      define_method m, ->() { @q[i] }
      define_method "#{m}=", ->(v) { @q[i] = v }
    end

    def angle
      Math.acos(w) * 2.0
    end

    def axis
      sa = 1.0 / Math.sqrt(1.0 - w * w)
      Vector3[x * sa, y * sa, z * sa]
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
      raise ArgumentError, "cross product not defined for #{q}" unless q.is_a? Quaternion
      self.class.new(
        w * q.w - x * q.x - y * q.y - z * q.z,
        w * q.x + x * q.w + y * q.z - z * q.y,
        w * q.y - x * q.z + y * q.w + z * q.x,
        w * q.z + x * q.y - y * q.x + z * q.w)
    end

    def difference(q)
      raise ArgumentError, "difference not defined for #{q}" unless q.is_a? Quaternion
      q * inverse
    end

    def dot_product(q)
      raise ArgumentError, "inner product not defined for #{q}" unless q.is_a? Quaternion
      w * q.w + x * q.x + y * q.y + z * q.z
    end

    def dup
      self.class.new(*@q)
    end

    def exp
      a = Math.sqrt(x * x + y * y + z * z)
      ew = Math.exp(w)
      s = ew * Math.sin(a) / a
      self.class.new(ew * Math.cos(a), x * s, y * s, z * s)
    end

    def freeze
      @q.freeze
      super
    end

    def imaginary
      [x, y, z]
    end

    def inverse
      conjugate / norm
    end

    def log
      nv = x * x + y * y + z * z
      nq = Math.sqrt(w * w + nv)
      s = Math.acos(w / nq) / Math.sqrt(nv)
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
      (log * p).exp
    end

    def real?
      false
    end

    def rotate(v3)
      v3 = Quaternion[0.0, *v3]
      v3 = self * v3 * conjugate
      Vector3[v3.x, v3.y, v3.z]
    end

    def squared_norm
      w * w + x * x + y * y + z * z
    end

    def to_a
      @q.dup
    end

    def to_angle_axis
      [angle, axis]
    end

    def to_s(notation = nil)
      case notation
        when :scalar
          "<Quaternion(w: #{w}, x: #{x}, y: #{y}, z: #{z})>"
        when :vertical
          "w: #{w}\nx: #{x}\ny: #{y}\nz: #{z}"
        else
          "<Quaternion(#{w}, [#{x}, #{y}, #{z}])>"
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

    alias_method :conj,    :conjugate
    alias_method :conj!,   :conjugate
    alias_method :cross,   :cross_product
    alias_method :dot,     :dot_product
    alias_method :im,      :imaginary
    alias_method :imag,    :imaginary
    alias_method :inspect, :to_s
    alias_method :inv,     :inverse
    alias_method :length,  :norm
    alias_method :re,      :w
    alias_method :real,    :w
  end
end
