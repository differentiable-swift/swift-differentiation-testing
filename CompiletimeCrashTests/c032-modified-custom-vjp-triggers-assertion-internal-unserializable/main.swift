// https://github.com/swiftlang/swift/issues/58246
// Regression: Custom VJP causes assertion failure: internal/private function cannot be serialized

import _Differentiation

extension SIMD
where
    Self: Differentiable,
    Scalar: BinaryFloatingPoint & Differentiable,
    Scalar.TangentVector: BinaryFloatingPoint,
    TangentVector == Self
{
    @inlinable
    @derivative(of: sum)
    @_alwaysEmitIntoClient
    public func _vjpSum() -> (
        value: Scalar, pullback: (Scalar.TangentVector) -> TangentVector
    ) {
        return (sum(), { v in Self(repeating: Scalar(v)) })
    }
}
