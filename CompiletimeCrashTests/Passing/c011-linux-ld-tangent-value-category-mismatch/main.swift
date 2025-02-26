// https://github.com/swiftlang/swift/pull/65249
import _Differentiation

struct Dense: Differentiable {
    @differentiable(reverse)
    var bias: Float?
}
