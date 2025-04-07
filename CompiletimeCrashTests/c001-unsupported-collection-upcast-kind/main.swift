#if canImport(_Differentiation)

// https://github.com/swiftlang/swift/issues/77871
// Crash due to type-checking failure in the pullback.

import _Differentiation

@differentiable(reverse)
func testFunc(_ x: Double?) -> Double? {
    x! * x! * x!
}
print(pullback(at: 1.0, of: testFunc)(.init(1.0)) == 3.0)
// This produces the correct diagnosis
// let pb = pullback(at: 1.0, of: testFunc)
// print(pb(.init(1.0)) == 3.0)

#endif
