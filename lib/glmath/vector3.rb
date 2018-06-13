module GLMath
  class Vector3 < Vector(%i{x y z})
    def *(v)
      case v
        when Numeric
          self.class.new(*@v.map{ |e| e * v })
        when Matrix3
          self.class.new(v[0] * x + v[3] * y + v[6] * z,
                         v[1] * x + v[4] * y + v[7] * z,
                         v[2] * x + v[5] * y + v[8] * z)
        else
          raise ArgumentError, "no implicit conversion of #{v.class} into Numeric or Matrix3"
      end
    end

    def expand(w)
      raise ArgumentError, "no implicit conversion of #{w.class} into Numeric" unless w.is_a? Numeric
      Vector4.new(*(@v + [w]))
    end

    def outer_product(v)
      v = v.instance_variable_get(:@v)
      self.class.new(@v[1]*v[2] - @v[2]*v[1], @v[2]*v[0] - @v[0]*v[2], @v[0]*v[1] - @v[1]*v[0])
    end

    alias_method :cross_product, :outer_product
    alias_method :cross,         :outer_product
  end
end