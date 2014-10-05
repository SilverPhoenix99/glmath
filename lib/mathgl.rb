$:.unshift File.dirname(File.expand_path(__FILE__))
module MathGL
    VERSION = '0.0.1'
    VERSION_CODENAME = 'Pitagoras'
end
module Math
  TAU = 2 * PI
end

%w'
   matrix
   matrix2
   matrix3
   matrix4
   vector
   vector2
   vector3
   vector4
   scalar
   quaternion
   euler_angle
   matrix_stack
'.each { |f| require "mathgl/#{f}" }

