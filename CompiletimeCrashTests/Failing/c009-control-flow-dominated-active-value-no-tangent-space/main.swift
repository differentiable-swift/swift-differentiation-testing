// https://github.com/swiftlang/swift/issues/54195
// https://github.com/swiftlang/swift/issues/79052
// Ternary operator is not differentiable
// used to crash pre 6.0, compilation error in 6.0.3

import _Differentiation

@differentiable
func TF_966(_ x: Float, _ bool: Bool) -> Float {
  let tuple = (x, 1)
  let result = bool ? tuple : tuple
  return result.0
}
