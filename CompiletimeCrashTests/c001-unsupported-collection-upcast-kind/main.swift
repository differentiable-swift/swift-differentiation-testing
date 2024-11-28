#if canImport(_Differentiation)

import _Differentiation

@differentiable(reverse)
func testFunc(_ x: Double?) -> Double? {
    x! * x! * x!
}
print(pullback(at: 1.0, of: testFunc)(.init(1.0)) == 3.0)

#endif
