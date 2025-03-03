import _Differentiation

// https://github.com/swiftlang/swift/issues/68402
// Assertion failure when differentiable function returns the result of another differentiable function.

struct I: Differentiable {
    @noDerivative var c: [Bool]
    var v: [Float]
    var d: Float
}
@differentiable(reverse,wrt: (v, d)) public func f(_ c: [Bool], _ v: [Float], _ d: Float) -> Float {
    return d
}
@differentiable(reverse,wrt: (v, d)) public func j(_ c: [Bool], _ v: [Float], _ d: Float) -> Float {
    let x = I(c: c, v: v, d: d)
    return f(x.c, x.v, x.d)
}
