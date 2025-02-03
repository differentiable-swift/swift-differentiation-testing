// https://github.com/swiftlang/swift/issues/53490
import _Differentiation

class Super: Differentiable {
    var base: Float = 0
    // Dummy to make `Super.AllDifferentiableVariables` be nontrivial.
    // var _nontrivial: [Float] = []

    @differentiable(wrt: self)
    func f() -> Float {
        return 1
    }
}

class Sub: Super {
    @differentiable(wrt: self)
    override func f() -> Float {
        return 1
    }
}
