module GLMath
  class Vector2

    SIZE = 2

    include Vector

    class << self
      def x
        new(1.0, 0.0)
      end

      def y
        new(0.0, 1.0)
      end
    end

    X = x.freeze
    Y = y.freeze

    def *(v)
      case v
        when Numeric
          self.class.new(*@v.map{ |e| e * v })
        when Matrix2
          self.class.new(x * v[0] + y * v[2], x * v[1] + y * v[3])
        else
          raise ArgumentError
      end
    end

    def expand(*args)
      args.flatten!
      case
        when args.length == 1 && args[0].is_a?(Vector2)
          Vector4.new(*(@v + args[0].to_a))
        when args.length == 1 && args[0].is_a?(Numeric)
          Vector3.new(*(@v + args))
        when args.length == 2 && args.all? { |e| e.is_a?(Numeric) }
          Vector4.new(*(@v + args))
        else
          raise ArgumentError
      end
    end
  end
end