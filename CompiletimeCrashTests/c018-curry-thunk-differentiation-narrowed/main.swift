import _Differentiation

// https://github.com/swiftlang/swift/issues/54819
// https://github.com/swiftlang/swift/issues/54819#issuecomment-1112561793

struct Box<Scalar> {
    var x: Scalar
}

extension Box: Differentiable where Scalar: Differentiable {}

struct Box2<T> {
    var x2: @differentiable(reverse) (Box<T>) -> Box<T>
}
