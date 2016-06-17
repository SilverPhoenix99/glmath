require_relative 'test_helper'

v1 = MathGL::Vector2[1, 2]
v2 = MathGL::Vector2[3, 4]
# v3 = v1 + v2
# v4 = v2 - v1
# v5 = v2 * 2
# v6 = v1.normalize
# v7 = glmath::Vector2.zero
# v3 = glmath::Vector3[1.0, 2.0, 3.0]
# puts v3.cross(v3)
# puts v3 + v3
# puts v3.is_a?(glmath::Vector)
# puts v3 + :a
# v0 = glmath::Vector2.zero
# puts v0.zero?

# m1 = glmath::Matrix2.I
# m2 = glmath::Matrix2[0, -4, 3, 7]
# m3 = m1 + m2
# m4 = m1 * m3
# m5 = m4.transpose
# m6 = glmath::Matrix2[3, 1, 2, -3]
# m7 = m4 * m6
# m8 = 3 * m1
#
# l, u, p = m6.lup
#
# m9 = l * u
# m10 = glmath::Matrix2[2, Complex(0, 1), Complex(0, -1), 1]
# m11 = glmath::Matrix2[Complex(0, 1), 0, 0, Complex(3, -5)]
# m12 = glmath::Matrix2[4, 3, 2, 1]
# m13 = m6.inv
#
# v8 = m7 * v1
# v9 = v2 * m6
# v10 = 3 * v1
#
# m31 = glmath::Matrix3.I
# m32 = glmath::Matrix3[1, 2, 3, 4, 5, 6, 7, 8, 9]
# m33 = glmath::Matrix3[9, 8, 7, 6, 5, 4, 3, 2, 1]
# m34 = m31 + m32
# m35 = m33 - m31
# m36 = m31 * 2
# m37 = m31 * m32
# m38 = m33 * m32
# m39 = m38.transpose
# m40 = glmath::Matrix3[3, 2, 1, 2, -3,  1, 4, 3, -5]
# m41 = m40.inv
# m42 = m40.adjoint
#
# m50 = glmath::Matrix4.I
# m51 = glmath::Matrix4[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
# m52 = m50 * m51
# m53 = glmath::Matrix4[3, 2, 1, 2, -3,  1, 4, 3, -5, 2, -3, 1, 2, 3, 4, 5]
# m54 = m53.inv
# m55 = m53.adjoint
# m56 = m53 * m54
#
#
# #(1..10).map { |x| "v#{x}" }.each { |x| p instance_eval(x) }
# #(1..13).map { |x| "m#{x}.to_s(:matrix)" }.each { |x| puts (instance_eval(x) + "\n\n") }
# #(31..42).map { |x| "m#{x}.to_s(:matrix)" }.each { |x| puts (instance_eval(x) + "\n\n") }
# #(50..56).map { |x| "m#{x}.to_s(:matrix)" }.each { |x| puts (instance_eval(x) + "\n\n") }
#
# p m31.normal?
# p m31.trace
# print "\n"
# p m41.det
# p m41.trace
# print "\n"
# p m53.det
# p m53.trace


m0 = MathGL::Matrix2[1.0, 2.0, 3.0, 4.0]

puts m0.adjoint
puts m0.determinant
puts m0.adjoint * (1/m0.determinant)
puts m0.inverse
puts m0/m0