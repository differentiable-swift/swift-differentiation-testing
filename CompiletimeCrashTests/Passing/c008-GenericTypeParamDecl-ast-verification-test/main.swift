// https://github.com/swiftlang/swift/pull/65249

import _Differentiation

public protocol Layer: Differentiable {
    associatedtype Input: Differentiable
    associatedtype Output: Differentiable
    var differentiableVectorView: TangentVector { get }

    @differentiable(reverse)
    func callAsFunction(_ input: Input) -> Output
}

extension Differentiable {
    @differentiable(reverse)
    public func sequenced<L1: Layer, L2: Layer>(through l1: L1, _ l2: L2) -> L2.Output
    where L1.Input == Self, L1.Output == L2.Input {
        let o1 = l1(self)
        return l2(o1)
    }
}
