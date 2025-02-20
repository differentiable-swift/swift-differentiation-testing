// ===========================================
// https://github.com/apple/swift/issues/68774
// ===========================================

import _Differentiation

@differentiable(reverse)
func f(_ x: Double) -> Double {
    return ifs([x < 0.0, x > 0.0], [3.0 * x, 5.0 * x], 7.0 * x)
}

// Compiler says that this is not differentiable
@differentiable(reverse,wrt: (values, defaultValue))
public func ifs(_ conditions: [Bool], _ values: [Double], _ defaultValue: Double) -> Double {
    let count = withoutDerivative(at: min(values.count, conditions.count))
    for i in 0..<count {
        if conditions[i] { return values[i] }
    }
    return defaultValue
}

// But it can be made differentiable like so
// @differentiable(reverse)
// func f(_ x: Double) -> Double {
//     let localValue = withoutDerivative(at: x)
//     return ifs([localValue < 0.0, localValue > 0.0], [3.0 * x, 5.0 * x], 7.0 * x) // desired implementation
// }
