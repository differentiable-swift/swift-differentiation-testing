// https://github.com/swiftlang/swift/issues/58246
// Regression: Custom VJP causes assertion failure: internal/private function cannot be serialized

import _Differentiation

extension SIMD
where
    Self: Differentiable,
    Scalar: BinaryFloatingPoint & Differentiable,
    Scalar.TangentVector: BinaryFloatingPoint,
    TangentVector == Self,
    Scalar == Scalar.TangentVector
{
    @inlinable
    @derivative(of: Self.init(repeating:))
    @_transparent
    @_alwaysEmitIntoClient
    public static func _vjpRep(_ value: Scalar) -> (
        value: Self, pullback: (Self.TangentVector) -> Scalar.TangentVector
    ) {
        let value = Self.init(repeating: value)
        func pullback(_: Self.TangentVector) -> Scalar.TangentVector {
            return value.sum()
        }
        return (value: value, pullback: pullback)
    }
}
