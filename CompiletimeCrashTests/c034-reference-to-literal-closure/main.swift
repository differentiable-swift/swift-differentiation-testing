#if canImport(_Differentiation)

// TODO: swift issue:

import _Differentiation

@_optimize(none)
public func blackHole(_: some Any) {}

@differentiable(reverse)
func testFunc(a: Float) -> Float {
    return a * 2
}

for _ in 0..<10 {
    let thing = gradient(at: 2, of: testFunc)
    blackHole(thing)
}

#endif
