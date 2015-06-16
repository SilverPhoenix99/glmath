module Math
  TAU = 2 * PI
end

require_relative 'version'

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
'.each { |f| require_relative "mathgl/#{f}" }

