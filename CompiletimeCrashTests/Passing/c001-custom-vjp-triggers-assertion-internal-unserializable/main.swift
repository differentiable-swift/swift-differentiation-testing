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
    public func _vjpSum() -> (
        value: Scalar, pullback: (Scalar.TangentVector) -> TangentVector
    ) {
        return (sum(), { v in Self(repeating: Scalar(v)) })
    }
}
