module MathGL
  class Matrix3

    class << self
      def dimension
        3
      end
    end

    include Matrix

    def *(v)
      case v
      when Vector3
        v.class.new(@m[0] * v.x + @m[1] * v.y + @m[2] * v.z,
                    @m[3] * v.x + @m[4] * v.y + @m[5] * v.z,
                    @m[6] * v.x + @m[7] * v.y + @m[8] * v.z)
      when Matrix3
        m = v.instance_variable_get(:@m)
        self.class.new(
          @m[0]*m[0]+@m[1]*m[3]+@m[2]*m[6], @m[0]*m[1]+@m[1]*m[4]+@m[2]*m[7], @m[0]*m[2] + @m[1]*m[5] + @m[2]*m[8],
          @m[3]*m[0]+@m[4]*m[3]+@m[5]*m[6], @m[3]*m[1]+@m[4]*m[4]+@m[5]*m[7], @m[3]*m[2] + @m[4]*m[5] + @m[5]*m[8],
          @m[6]*m[0]+@m[7]*m[3]+@m[8]*m[6], @m[6]*m[1]+@m[7]*m[4]+@m[8]*m[7], @m[6]*m[2] + @m[7]*m[5] + @m[8]*m[8])
      else
        super
      end
    end

    def adjugate!
      @m =[@m[4] * @m[8] - @m[5] * @m[7],
           @m[5] * @m[6] - @m[3] * @m[8],
           @m[3] * @m[7] - @m[4] * @m[6],
           @m[2] * @m[7] - @m[1] * @m[8],
           @m[0] * @m[8] - @m[2] * @m[6],
           @m[1] * @m[6] - @m[0] * @m[7],
           @m[1] * @m[5] - @m[2] * @m[4],
           @m[2] * @m[3] - @m[0] * @m[5],
           @m[0] * @m[4] - @m[1] * @m[3]]
      self
    end

    def determinant
      @m[0] * (@m[4] * @m[8] - @m[5] * @m[7]) +
      @m[1] * (@m[5] * @m[6] - @m[3] * @m[8]) +
      @m[2] * (@m[3] * @m[7] - @m[4] * @m[6])
    end

    def expand
      m = @m.dup
      m[3,  0] = 0.0
      m[7,  0] = 0.0
      m[11, 0] = [0.0, 0.0, 0.0, 0.0, 1.0]
      Matrix4.new(*m)
    end

    def lup
      #TODO
    end

    def permutation?
      #TODO
    end

    def to_s(notation = nil)
      #TODO
      case notation
      when nil     then "Matrix3#{@m}"
      when :matrix then "#{self[0]}\t#{self[3]}\t#{self[6]}\n#{self[1]}\t#{self[4]}\t#{self[7]}\n#{self[2]}\t#{self[5]}\t#{self[8]}"
      end
    end

    alias_method :det,               :determinant
    alias_method :lup_decomposition, :lup
  end
end