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
        self.class.new(x *  v[0] + y *  v[1] + z *  v[2] + w *  v[3],
                       x *  v[4] + y *  v[5] + z *  v[6] + w *  v[7],
                       x *  v[8] + y *  v[9] + z * v[10] + w * v[11],
                       x * v[12] + y * v[13] + z * v[14] + w * v[15])
      end
    end

    def size
      4
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