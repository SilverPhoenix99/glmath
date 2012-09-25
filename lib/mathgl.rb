$:.unshift File.dirname(File.expand_path(__FILE__))

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
   quaternions
   eulerangle
'.each { |f| require f }

#mathn