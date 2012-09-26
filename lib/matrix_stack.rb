module MathGL
  class MatrixStack

    def initialize
      @stack = [Matrix4.I]
    end

    %w'* - +'.each do |m|
      define_method(m, ->(v) do
        @stack[-1] = @stack.last.send(m, check(v))
        self
      end)
    end

    def current
      @stack.last.dup
    end

    def <<(m)
      @stack << check(m)
      self
    end

    def push(m = nil)
      self << (m || current)
    end

    def pop(n = 1)
      @stack.pop(n)
    end

    def load(m)
      @stack[-1] = check(m)
    end

    def load_identity
      load(Matrix4.I)
    end

    def rotate(arg, axis = nil)
      self * case
      when axis != nil
        n = axis.normalize
        ct = cos arg
        st = sin arg
        ct1 = 1 - ct
        xy = n.x * n.y * ct1
        xz = n.x * n.z * ct1
        yz = n.y * n.z * ct1

        Matrix4[n.x * n.x  * ct1 + ct, xy  + n.z * st, xz - n.y * st, 0,
                xy  - n.z * st, n.y * n.y  * ct1 + ct, yz + n.x * st, 0,
                xz + n.y * st, yz - n.x * st, n.z * n.z * ct1 + ct, 0,
                0, 0, 0, 1]
      when [Quaternion, EulerAngle].any?{ |c| arg.is_a?(c) }
        arg.to_matrix
      else
        raise ArgumentError
      end
    end

    def scale(x, y, z)
      self * Matrix4[x,0,0,0,0,y,0,0,0,0,z,0,0,0,0,1]
    end

    def shear()

    end

    def translate(x, y, z)
      self * Matrix4[1,0,0,x,0,1,0,y,0,0,1,z,0,0,0,1]
    end

    private
    def check(m)
      raise ArgumentError unless m.is_a? Matrix4
      m
    end

  end
end
