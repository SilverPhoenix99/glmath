module GLMath
  class Vector4 < Vector(%i{x y z w})
    def *(v)
      case v
        when Numeric
          self.class.new(*@v.map{ |e| e * v })
        when Matrix4
          self.class.new(x * v[0] + y * v[4] + z * v[ 8] + w * v[12],
                         x * v[1] + y * v[5] + z * v[ 9] + w * v[13],
                         x * v[2] + y * v[6] + z * v[10] + w * v[14],
                         x * v[3] + y * v[7] + z * v[11] + w * v[15])
        else
          raise ArgumentError
      end
    end
  end
end