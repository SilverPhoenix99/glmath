require_relative 'test_helper'

include MathGL

v = Vector2[1.0, 1.0].normalize!
angle = Math.acos(v.x)
m = Matrix2.rotation(angle)
p v, m
p v * m