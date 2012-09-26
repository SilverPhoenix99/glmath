module MathGl
  class EulerAngle
    def initialize(y, r, p)
      @e = y, r, p
    end

    %w'y r p'.each.each_with_index do |m, i|
      define_method m, ->(){ @q[i] }
      define_method "#{m}=", ->(v){ @q[i] = v }
    end

    def to_matrix(*args)
      args = [:y, :p, :r] if args.length == 0
      cy, sy, cp, sp, cr, sr = nil
      args.map do |i|
        case i
        when :y, :yaw, :h, :heading
          cy ||= cos(y)
          sy ||= sin(y)
          Matrix4[cy, 0, -sy, 0, 0, 1, 0, 0, sy, 0, cy, 0, 0, 0, 0, 1]
        when :p, :pitch
          cp ||= cos(p)
          sp ||= sin(p)
          Matrix4[1, 0, 0, 0, 0, cp, sp, 0, 0, -sp, cp, 0, 0, 0, 0, 1]
        when :r, :roll, :b, :bank
          cr ||= cos(r)
          sr ||= sin(r)
          Matrix4[cr, sr, 0, 0, -sr, cr, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        else
          1
        end
      end.reduce(&:*)
    end

    alias_method :h, :y
    alias_method :b, :r
  end
end