module GLMath
  class Line

  end

  class LineSegment
    def initialize(x1, y1, z1 = 0, x2, y2, z2 = 0)
      @start_point = Vector3[x1, y1, z1]
      @end_point = Vector3[x2, y2, z2]
      @vector = @end_point - @start_point
    end

    def length
      @vector.length
    end


  end
end