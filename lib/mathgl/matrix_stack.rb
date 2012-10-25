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

    def push(m = current)
      self << m
      return self unless block_given?
      yield self #block.(self)
      pop
      self
    end

    def pop(n = 1)
      @stack.pop(n)
    end

    def load(*args)
      @stack[-1] = case
      when args.length == 16
        Matrix4[*args]
      when args.length == 9
        Matrix3[*args].expand
      when args.length == 1
        check(args[0])
      else
        raise ArgumentError
      end
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
