import Foundation
import Testing
import _Differentiation
import Gen
import ValidationTesting

@differentiable(reverse, wrt: x)
func laurentPolynomial(variable x: Double, coefficients: Dictionary<Int, Double>, center c: Double) -> Double {
    var result = 0.0
    for (n, coefficient) in coefficients {
        let n = Double(n)
        result += coefficient * pow(x - c, n)
    }
    return result
}

func laurentPolynomialDerivative(variable x: Double, coefficients: Dictionary<Int, Double>, center c: Double) -> Double {
    var result = 0.0
    for (n, coefficient) in coefficients {
        if n == 0 { continue }
        let n = Double(n)
        result += n * coefficient * pow(x - c, n - 1)
    }
    return result
}

@Test(arguments:
        zip(
            Gen.double(in: -10.0...10.0),
            zip(Gen.int(in: -20...20), Gen.double(in: -100...100)).dictionary(ofAtMost: Gen.int(in: 0...100)),
            Gen.always(0)
        ).array(of: .always(10)).run()
)
func laurentPolynomials(x: Double, coefficients: [Int: Double], center: Double) {
    validateGradient(
        of: { x in laurentPolynomial(variable: x, coefficients: coefficients, center: center) },
        with: { x in laurentPolynomialDerivative(variable: x, coefficients: coefficients, center: center) },
        at: x
    )
}
