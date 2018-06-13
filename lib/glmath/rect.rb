module GLMath

  # Convention: +y axis is down
  class Rect
    attr_reader :x, :y, :width, :height

    def self.from_points(p1, p2)
      px = [p1.x, p2.x].sort
      py = [p1.y, p2.y].sort
      x = px.first
      y = py.first
      width = px.last - px.first
      height = py.last - py.first

      new(x: x, y: y, width: width, height: height)
    end

    def self.from_center(cx: 0, cy: 0, width: 0, height: 0)
      new(x: cx - width / 2, y: cy - height / 2, width: width, height: height)
    end

    def self.square(x: 0, y: 0, size: 0)
      new(x: x, y: y, width: size, height: size)
    end

    def initialize(x: 0, y: 0, width: 0, height: 0)
      @x = x
      @y = y
      @width = width
      @height = height
    end

    def [](v)
      send v
    end

    def ==(r)
      return false unless r.is_a? Rect
      %w(x y width height).all?{ |v| self[v] == r[v] }
    end

    def top
      y
    end

    def bottom
      y + height
    end

    def left
      x
    end

    def right
      x + width
    end

    def center
      [center_x, center_y]
    end

    def center_x
      x + width / 2
    end

    def center_y
      y + height / 2
    end

    def include?(x, y)
      (left..right).include?(x) && (bottom..top).include?(y)
    end

    def outside?(x, y)
      !include?(x, y)
    end

    def to_a
      [left, bottom, width, height]
    end

    def area
      width * height
    end

    def perimeter
      2 * (width + height)
    end

    def to_s
      "<Rect #{%w'x y width height'.map { |name| "#{name} = #{send(name)}" }.join(', ')}>"
    end

    def vertices(format = :strip)
      case format
      when :strip then [[left, top], [right, top], [left, bottom], [right, bottom]]
      when :cycle then [[left, top], [right, top], [right, bottom], [left, bottom]]
      else nil
      end
    end

    alias_method :to_ary, :to_a
    alias_method :inside?, :include?

  end
end