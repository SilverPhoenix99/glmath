require_relative 'test_helper'
include MathGL

ms = MatrixStack.new
v = Vector4[1, 2, 3, 1]
def pms(a)
  p a
  puts a.current.to_s(:matrix)
end
ms.push
pms(ms)
ms.pop
pms(ms)
ms.push
ms.translate(5, 3, -2)
pms(ms)
ms.scale(-2, 5, 3)
pms ms
ms.rotate(TAU/2, Vector3[1, 1, 0])
pms(ms)
puts v * ms.current
