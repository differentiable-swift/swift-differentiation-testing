// https://github.com/swiftlang/swift/issues/55179

import _Differentiation

public class Tracked<T> {}
extension Tracked: Differentiable where T: Differentiable {}

@differentiable(reverse)
func callback(_ x: inout Tracked<Float>.TangentVector) {}

public extension Differentiable {
  /// Applies the given closure to the derivative of `self`.
  ///
  /// Returns `self` like an identity function. When the return value is used in
  /// a context where it is differentiated with respect to, applies the given
  /// closure to the derivative of the return value.
  @inlinable
  @differentiable(reverse, wrt: self)
  func withDerivative(_ body: @escaping (inout TangentVector) -> Void) -> Self {
    return self
  }

  @inlinable
  @derivative(of: withDerivative)
  internal func _vjpWithDerivative(
    _ body: @escaping (inout TangentVector) -> Void
  ) -> (value: Self, pullback: (TangentVector) -> TangentVector) {
    return (self, { grad in
      var grad = grad
      body(&grad)
      return grad
    })
  }
}

@differentiable(reverse)
func caller(_ x: Tracked<Float>) -> Tracked<Float> {
  return x.withDerivative(callback)
}
