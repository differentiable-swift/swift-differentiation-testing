// ===============================================
// https://github.com/swiftlang/swift/issues/55207
// ===============================================
import _Differentiation

func f(_ v: [Double]) -> Double {
  return 0
}

let g = gradient(at: [0], of: f)
let g2 = g  // Succeeds!

func doGradient<A: Differentiable>(
  of f: @differentiable(A) -> Double,
  at p: A
) where A.TangentVector == Array<Double>.DifferentiableView {
  let g = gradient(at: p, of: f)
  let g2 = g  // Segfaults!
}

doGradient(of: f, at: [0])
