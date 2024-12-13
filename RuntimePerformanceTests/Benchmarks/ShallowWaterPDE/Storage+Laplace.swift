import _Differentiation

extension Array2DStorage where Element == Float {
    /// Applies discretized Laplace operator to scalar field `u` at grid points `x` and `y`.
    @differentiable(reverse)
    @inlinable
    func laplace(_ x: Int, _ y: Int) -> Float {
        self[x, y + 1] + self[x - 1, y] - (4 * self[x, y]) + self[x + 1, y] + self[x, y - 1]
    }
}
