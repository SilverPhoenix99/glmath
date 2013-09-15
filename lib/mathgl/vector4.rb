module MathGL
  class Vector4

    class << self
      def size
        4
      end
    end

    include Vector

    def initialize(x, y, z, w)
      @v = [x, y, z, w]
      raise ArgumentError, "It's not numeric" unless @v.all? { |e| Numeric === e }
    end

    def *(v)
      case v
        when Numeric
          self.class.new(*@v.map{ |e| e * v })
        when Vector4
          raise ArgumentError, "Operation '*' not valid for Vector3"
        when Matrix4
          self.class.new(x * v[0] + y * v[4] + z * v[ 8] + w * v[12],
                         x * v[1] + y * v[5] + z * v[ 9] + w * v[13],
                         x * v[2] + y * v[6] + z * v[10] + w * v[14],
                         x * v[3] + y * v[7] + z * v[11] + w * v[15])
      end
    end

    def z
      @v[2]
    end

    def w
      @v[3]
    end

    %w(xy xz xw yz yw zw xyz xyw xzw yzw).each do |m|
      instance_eval("def #{m}() Vector#{m.length}.new(#{m.each_char.to_a.join(', ')}) end")
    end
  end
end