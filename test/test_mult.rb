require_relative 'test_helper'
include MathGL

#t = Matrix3.translation(1.0, 2.0, 3.0)
#s = Matrix3.scale(1.0, 2.0, 3.0, true)
#v = Vector4[1.0, 2.0, 3.0, 1.0]
#
#p t * s * v
#p s * t * v
#puts
#
#ms = MatrixStack.new
#ms.push do
#  ms.translate(1.0, 2.0, 3.0)
#  ms.scale(1.0, 2.0, 3.0)
#  p ms.current * v
#end
#
#ms.push do
#  ms.scale(1.0, 2.0, 3.0)
#  ms.translate(1.0, 2.0, 3.0)
#  p ms.current * v
#end

ms = MatrixStack.new
ms.scale(100.0, 100.0, 1.0)
ms.translate(15.0, 15.0, 0.0)

p ms.current