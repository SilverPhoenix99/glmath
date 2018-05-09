module GLMath
  class Rect
    attr_accessor :x, :y, :width, :height

    def self.from_points(p1, p2)
      new(x: p1.x, y: p1.y, width: p2.x - p1.x, height: p2.y - p1.y)
    end

    def self.from_center(cx: 0, cy: 0, width: 0, height: 0)
      new(x: cx - width / 2, y: cy + height / 2, width: width, height: height)
    end

    def initialize(x: 0, y: 0, width: 0, height: 0, &block)
      @x = x
      @y = y
      @width = width
      @height = height
      ergo(&block)
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

    def center_x
      @x + @width / 2
    end

    def center_y
      @y + @height / 2
    end

    def center
      [center_x, center_y]
    end

    def center=(c)
      cx, cy = c
      @x, @y = cx - width / 2, cy + height / 2
    end

    def include?(x, y)
      (left..right).include?(x) && (bottom..top).include?(y)
    end

    def outside?(x, y)
      !include?(x, y)
    end

    def right
      @x + @width
    end

    def right=(v)
      @width = v - @x
    end

    def bottom
      @y - @height
    end

    def bottom=(v)
      @height = top - v
    end

    def left_top
      Vector2.new(left, top)
    end

    def left_bottom
      Vector2.new(left, bottom)
    end

    def right_top
      Vector2.new(right, top)
    end

    def right_bottom
      Vector2.new(right, bottom)
    end

    def to_a
      [left, top, width, height]
    end

    def to_s
      "<Rect #{%w'left bottom width height'.map { |name| "#{name} = #{send(name)}" }.join(', ')}>"
    end

    def vertices(format: :strip)
      case format
        when :strip then [[left, top], [right, top], [left, bottom], [right, bottom]]
        when :cycle then [[left, top], [right, top], [right, bottom], [left, bottom]]
        else nil
      end
    end

    def area
      @width * @height
    end

    def perimeter
      2 * (@width + @height)
    end

    alias_method :inside?, :include?
    alias_method :to_ary,  :to_a
    alias_method :left,    :x
    alias_method :left=,   :x=
    alias_method :top,     :y
    alias_method :top=,    :y=
  end
end