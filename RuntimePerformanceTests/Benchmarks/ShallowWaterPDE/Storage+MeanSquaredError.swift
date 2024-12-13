import _Differentiation

extension Array2DStorage where Element == Float {
    /// Calculates mean squared error loss between the solution and a `target` grayscale image.
    @differentiable(reverse, wrt: self)
    func meanSquaredError(to target: Array2DStorage<Float>) -> Float {
        var mse: Float = 0.0

        for x in 0 ..< withoutDerivative(at: width) {
            for y in 0 ..< withoutDerivative(at: height) {
                let error = target[x, y] - self[x, y]
                mse += error * error
            }
        }
        return mse / Float(width) / Float(height)
    }
}
