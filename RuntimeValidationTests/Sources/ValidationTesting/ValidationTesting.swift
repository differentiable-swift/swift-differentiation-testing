import _Differentiation
import Numerics
import Testing

// MARK: Gradient Validation

public func validateGradient<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with gradientTruth: (S) -> S.TangentVector,
    at point: S
) where S: Differentiable, T: Differentiable, T: FloatingPoint, T == T.TangentVector, S.TangentVector: FloatingPoint {
    validateGradient(
        of: function,
        with: gradientTruth,
        at: point,
        validation: { gradient, trueGradientValue in
            gradient.isApproximatelyEqual(to: trueGradientValue)
        }
    )
}

public func validateGradient<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with gradientTruth: (S) -> S.TangentVector,
    at point: S,
    validation: (S.TangentVector, S.TangentVector) -> Bool
) where S: Differentiable, T: Differentiable, T: FloatingPoint, T == T.TangentVector {
    let vwpb = valueWithGradient(at: point, of: function)
    
    let gradient = vwpb.gradient
    let gradientTruth = gradientTruth(point)
    
    #expect(validation(gradient, gradientTruth))
}

// MARK: VJP Validation

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S
) where S: Differentiable, T: Differentiable, T: FloatingPoint, T == T.TangentVector, S.TangentVector: FloatingPoint {
    validateVJP(
        of: function,
        with: vjpTruth,
        at: point,
        withTangentVector: .init(1), // TODO: we shouldn't set this as we need to validate a variety of tangentVectors as well to fully validate the vjp
        valueValidation: { gradient, gradientTruth in gradient == gradientTruth }
    )
}

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S,
    pullbackValidation: (S.TangentVector, S.TangentVector) -> Bool
) where S: Differentiable, T: Differentiable, T: FloatingPoint, T == T.TangentVector {
    validateVJP(
        of: function,
        with: vjpTruth,
        at: point,
        withTangentVector: .init(1), // TODO: we shouldn't set this as we need to validate a variety of tangentVectors as well to fully validate the vjp
        valueValidation: { value, valueTruth in value == valueTruth },
        pullbackValidation: pullbackValidation
    )
}

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> (T),
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S,
    withTangentVector tangentVector: T.TangentVector
) where S: Differentiable, T: Differentiable & Equatable, S.TangentVector: FloatingPoint {
    validateVJP(
        of: function,
        with: vjpTruth,
        at: point,
        withTangentVector: tangentVector,
        valueValidation: { value, valueTruth in value == valueTruth },
        pullbackValidation: { gradient, trueGradient in
            gradient.isApproximatelyEqual(to: trueGradient)
        }
    )
}

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S,
    withTangentVector tangentVector: T.TangentVector,
    valueValidation: (T, T) -> Bool
) where S: Differentiable, T: Differentiable, S.TangentVector: FloatingPoint {
    validateVJP(
        of: function,
        with: vjpTruth,
        at: point,
        withTangentVector: tangentVector,
        valueValidation: valueValidation,
        pullbackValidation: { gradient, trueGradient in
            gradient.isApproximatelyEqual(to: trueGradient)
        }
    )
}

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S,
    withTangentVector tangentVector: T.TangentVector,
    pullbackValidation: (S.TangentVector, S.TangentVector) -> Bool
) where S: Differentiable, T: Differentiable & Equatable {
    validateVJP(
        of: function,
        with: vjpTruth,
        at: point,
        withTangentVector: tangentVector,
        valueValidation: { value, valueTruth in value == valueTruth },
        pullbackValidation: pullbackValidation
    )
}

public func validateVJP<S, T>(
    of function: @differentiable(reverse) (S) -> T,
    with vjpTruth: (S) -> (value: T, pullback: (T.TangentVector) -> S.TangentVector),
    at point: S,
    withTangentVector tangentVector: T.TangentVector,
    valueValidation: (T, T) -> Bool,
    pullbackValidation: (S.TangentVector, S.TangentVector) -> Bool
) where S: Differentiable, T: Differentiable {
    let vwpb = valueWithPullback(at: point, of: function)
    let vwpbTruth = vjpTruth(point)
    
    let value = vwpb.value
    let valueTruth = vwpbTruth.value
    
    let pullback = vwpb.pullback(tangentVector)
    let pullbackTruth = vwpb.pullback(tangentVector)

    #expect(valueValidation(value, valueTruth))
    #expect(pullbackValidation(pullback, pullbackTruth))
}
