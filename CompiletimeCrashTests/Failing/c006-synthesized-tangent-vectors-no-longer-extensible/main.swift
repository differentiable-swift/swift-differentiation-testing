import _Differentiation

// https://github.com/swiftlang/swift/issues/60461
// Regression: synthesized `TangentVectors` for `Differentiable` types can no longer be extended.

protocol TestProtocol {}

struct TestCase: Differentiable {
    var test1: Float
    var test2: Float
}

extension TestCase.TangentVector: TestProtocol {}
