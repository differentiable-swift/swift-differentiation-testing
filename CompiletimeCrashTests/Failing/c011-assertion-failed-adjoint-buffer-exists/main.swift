import _Differentiation

// https://github.com/swiftlang/swift/issues/75280
// https://github.com/swiftlang/swift/issues/79051
// Used to crash, compilation fails now: not differentiable

@differentiable(reverse) func a<F, A>(_ f: F?, c: @differentiable(reverse) (F) -> A) -> A?
where F: Differentiable, A: Differentiable {
    guard let f else { return nil }
    return c(f)
}
