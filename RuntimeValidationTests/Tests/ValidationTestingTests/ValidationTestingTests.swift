import _Differentiation
import Testing
import ValidationTesting

@differentiable(reverse)
func squared(_ x: Double) -> Double {
    x * x
}

func vjpSquaredTruth(_ x: Double) -> (value: Double, pullback: (Double) -> Double) {
    (
        value: x * x,
        pullback: { v in
            2 * x * v
        }
    )
}

func gradientSquaredTruth(_ x: Double) -> Double {
    2 * x
}

@Suite
struct ValidationTestingTests {
    @Test(arguments: [1.0])
    func testVJPValidation(x: Double) {
        validateVJP(
            of: { x in squared(x) }, // we can call the function directly with upcoming compiler fix
            with: vjpSquaredTruth,
            at: x
        )
    }
    
    @Test(arguments: [1.0])
    func testGradientValidation(x: Double) {
        validateGradient(
            of: { x in squared(x) }, // we can call the function directly with upcoming compiler fix
            with: gradientSquaredTruth,
            at: x
        )
    }
}
