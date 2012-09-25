module MathGl
  class Quaternion
    def initialize(w, x, y, z)
      @q = w, x, y, z
      raise ArgumentError, "Must be Numeric" unless @q.all? { |e| e.is_a? Numeric}
    end

    def +(v)
      case v
      when Real
        self.class.new(v + q, x, y, z)
      when Quaternion
        self.class.new(q + v.q, x + v.x, y + v.y, z + v.z)
      else
        v + self
      end
    end

    def - q
      self + -q
    end

    def *(v)
      case v
      when Real
        self.class.new(q * v, x * v, y * v, z * v)
      when Quaternion
        cross_product(v)
      end
    end

    def -@
      self.class.new *@q.map(&:-@)
    end

    %w'w x y z'.each_with_index do |m, i|
      define_method m, ->(){ @q[i] }
      define_method "#{m}=", ->(v){ @q[i] = v }
    end

    def coerce other
      return self, other
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

    end

    def dot_product(q)
      w * q.w + x * q.x + y * q.y + z * q.z
    end

    def inverse

    end

    def imaginary
      [x, y, z]
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

    def to_s(notation = nil)
      case notation
      when nil
        "(#{w}, #{x}, #{y}, #{z})"
      when :scalar_vector
        "(#{w}, [#{x}, #{y}, #{z}])"
      end

    end

    alias_method :conj,  :conjugate
    alias_method :conj!, :conjugate
    alias_method :im,    :imaginary
    alias_method :imag,  :imaginary
    alias_method :inv,   :inverse
    alias_method :re,    :real
  end
end