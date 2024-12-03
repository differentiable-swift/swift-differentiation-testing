import _Differentiation
import Gen
import Testing

@differentiable(reverse)
func oneOverX(_ x: Double) -> Double {
    1 / x
}

func _vjpOneOverX(_ x: Double) -> (value: Double, pullback: (Double) -> Double) {
    (
        value: 1 / x,
        pullback: { v in
            -v / (x * x)
        }
    )
}

func validateVJPWithError<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S
) where S: Differentiable, T: Differentiable, T: FloatingPoint, T == T.TangentVector, S.TangentVector: FloatingPoint, S.TangentVector == Double {
    let vwpb = valueWithPullback(at: point, of: function)
    let vwpbTruth = vjpTruth(point)
    
    let value = vwpb.value
    let valueTruth: T = vwpbTruth.value
    
    let pullback = vwpb.pullback(.init(1))
    let pullbackTruth = vwpbTruth.pullback(.init(1))

    #expect(value == valueTruth)
    withKnownIssue("Caused by S.TangentVector == Double generic requirement of this function, works fine when removed") {
        #expect(pullback == pullbackTruth)
    }
}

@Test(
    arguments: Gen.double(in: -100...100).array(of: .always(100)).run()
)
func testOneOverX(_ x: Double) {
    validateVJPWithError(of: { x in oneOverX(x) }, with: { x in _vjpOneOverX(x) }, at: x)
}
