import _Differentiation

// https://github.com/swiftlang/swift/issues/55882
// Compiler crashes for custom derivative of nil-coalescing operator.

@derivative(of: ??)
@usableFromInline
func _vjpNilCoalescing<T: Differentiable>(optional: T?, defaultValue: @autoclosure () throws -> T)
    rethrows -> (value: T, pullback: (T.TangentVector) -> Optional<T>.TangentVector)
{
    let hasValue = optional != nil
    let value = try optional ?? defaultValue()
    func pullback(_ v: T.TangentVector) -> Optional<T>.TangentVector {
        return hasValue ? .init(v) : .zero
    }
    return (value, pullback)
}
