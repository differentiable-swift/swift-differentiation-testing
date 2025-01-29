import _Differentiation

struct I: Differentiable {
    @noDerivative var c: [Bool]
    var d: Float
}
@differentiable(reverse,wrt: d) public func f(_ d: Float) -> Float { return d }
@differentiable(reverse,wrt: d) public func j(_ d: Float) -> Float {
    return f(I(c: [Bool](), d: d).d)
}
