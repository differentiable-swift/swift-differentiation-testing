// https://github.com/swiftlang/swift/issues/57946#issuecomment-1120439311
// Ostensibly minimized reproducer for the original one.

import _Differentiation

// `Root` can be constrained to `Differentiable` here, rather than in the
// extension. The crash happens either way.
struct TestKeyPaths<Root, Value> {}

// Adding `where Value == Int` causes the crash. Either removing that or
// substituting with `where Value: Differentiable` eliminates the crash.
extension TestKeyPaths where Root: Differentiable, Value == Int {
    @differentiable(reverse)
    static func readAll(from root: Root) -> Double {
        // Removing the force-unwrap eliminates the crash.
        let ignored = Root?(nil)!
        return 0
    }
}
