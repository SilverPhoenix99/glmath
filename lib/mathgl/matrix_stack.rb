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

    def <<(m)
      @stack << check(m)
      self
    end

    def current
      @stack.last.dup
    end

    def dup
      MatrixStack.new.tap { |ms| ms.instance_variable_set(:@stack, @stack.map(&:dup)) }
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
      when args.length == 16 then Matrix4[*args]
      when args.length == 9  then Matrix3[*args].expand
      when args.length == 1  then check(args[0])
      else raise ArgumentError
      end
    end

    def load_identity
      load(Matrix4.I)
    end

    def ortho(left, right, bottom, top, near, far)
      self * Matrix4.ortho(left, right, bottom, top, near, far)
    end

    def rotate(arg, axis = nil)
      self * case axis
             when Vector3, Vector4       then Matrix4.rotation(arg, axis)
             when Quaternion, EulerAngle then arg.to_matrix
             else raise ArgumentError
      end
    end

    def scale(x, y, z, w = 1.0)
      self * Matrix4.scale(x, y, z, w)
    end

    def shear()
      #TODO
    end

    def translate(x, y, z)
      self * Matrix4.translation(x, y, z)
    end

    private
    def check(m)
      raise ArgumentError unless m.is_a?(Matrix4)
      m
    end

  end
end
