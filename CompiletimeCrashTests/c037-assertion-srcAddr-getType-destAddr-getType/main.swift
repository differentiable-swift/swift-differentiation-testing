// https://github.com/swiftlang/swift/issues/72363
// Reproducer 2/2
import _Differentiation

protocol P {}
struct D: P, Differentiable {}
func a(_ x: P) {}
@differentiable(
    reverse
    where T == D
) func f<T: P>(_ x: T) -> T {
    a(x)
    return x
}
