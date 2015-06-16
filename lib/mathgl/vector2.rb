module MathGL
  class Vector2

    class << self
      def size
        2
      end
    end

    include Vector

    def *(v)
      case v
        when Numeric
          self.class.new(*@v.map{ |e| e * v })
        when Vector2
          raise ArgumentError, "Operation '*' not valid for Vector2"
        when Matrix2
          self.class.new(x * v[0] + y * v[2], x * v[1] + y * v[3])
      end
    end

    def expand(*args)
      args.flatten!
      case
        when args.length == 1 && args.is_a?(Vector2)
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