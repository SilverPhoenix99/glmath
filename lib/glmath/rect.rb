module GLMath
  class Rect
    attr_accessor :x, :y, :width, :height

    def initialize(x = 0, y = 0, width = 0, height = 0)
      self.x, self.y, self.width , self.height = x, y, width, height
    end

    def [](v)
      send v
    end

    def []=(k, v)
      send("#{k}=", v)
    end

    def ==(r)
      return false unless r.is_a? Rect
      %w(x y width height).map{ |v| self[v] == r[v] }.all?{ |v| v }
    end

    def bottom
      y
    end

    def bottom=(v)
      self.y = v
    end

    def center
      [center_x, center_y]
    end

    def center_x
      x + width/2
    end

    def center_y
      y + height/2
    end

    def center=(c)
      cx, cy = c
      self.x, self.y = cx - width/2, cy - height/2
    end

    def include?(x, y)
      (left..right).include?(x) && (bottom..top).include?(y)
    end

    def left
      x
    end

    def left=(v)
      self.x = v
    end

    def outside?(x, y)
      !include?(x, y)
    end

    def right
      x+width
    end

    def right=(v)
      self.width = v - x
    end

    def to_a
      [left, bottom, width, height]
    end

    def area
      width * height
    end

    def perimeter
      2 * width + 2 * area
    end

    def diagonals
      [diagonal_top_left, diagonal_top_right]
    end

    def diagonal_top_left
      LineSegment.new(top, left, bottom, right)
    end

    def diagonal_top_right
      LineSegment.new(top, right, bottom, left)
    end

    def diagonal_length
      Math.sqrt(width ** 2 + height ** 2)
    end

    def to_s
      "<Rect #{%w'left bottom width height'.map { |name| "#{name} = #{send(name)}" }.join(', ')}>"
    end

    def top
      y + height
    end

    def top=(v)
      self.height = v - y
    end

    def vertices(format = :strip)
      case format
      when :strip then [[left, top], [right, top], [left, bottom], [right, bottom]]
      when :cycle then [[left, top], [right, top], [right, bottom], [left, bottom]]
      else nil
      end
    end

    def self.from_center(cx, cy, width, height)
      new do
        self.x, self.y, self.width, self.height = cx - width/2, cy - height/2, width, height
      end
    end

    alias_method :to_ary, :to_a
    alias_method :inside?, :include?

  end

  class Square < Rect
    def initialize(x, y, size)
      super(x, y, size, size)
    end
  end
end