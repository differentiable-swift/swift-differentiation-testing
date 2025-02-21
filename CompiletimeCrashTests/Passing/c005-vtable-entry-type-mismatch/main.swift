// https://github.com/swiftlang/swift/issues/53490
// This error occurs because class Super is non-trivial but struct Super.AllDifferentiableVariables is trivial.
// Should be fixed by TF-625 by making differentials/pullbacks maximally indirect.

import _Differentiation

class Super: Differentiable {
    var base: Float = 0
    // Dummy to make `Super.AllDifferentiableVariables` be nontrivial.
    // var _nontrivial: [Float] = []

    @differentiable(reverse,wrt: self)
    func f() -> Float {
        return 1
    }
}

class Sub: Super {
    @differentiable(reverse,wrt: self)
    override func f() -> Float {
        return 1
    }
}
