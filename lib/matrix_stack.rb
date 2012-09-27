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
        Matrix4.rotation(arg, axis)
      when [Quaternion, EulerAngle].any?{ |c| arg.is_a?(c) }
        arg.to_matrix
      else
        raise ArgumentError
      end
    end

    def scale(x, y, z, w = 1)
      self * Matrix4.scale(x, y, z, w)
    end

    def shear()

    end

    def translate(x, y, z)
      self * Matrix4.translation(x, y, z)
    end

    private
    def check(m)
      raise ArgumentError unless m.is_a? Matrix4
      m
    end

  end
end
