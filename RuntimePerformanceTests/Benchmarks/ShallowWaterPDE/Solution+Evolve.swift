import _Differentiation

extension Solution {
    @differentiable(reverse)
    func evolve() -> Self {
        var newWaterLevel = currentWaterLevel

        for x in 1 ..< resolution - 1 {
            for y in 1 ..< resolution - 1 {
                // FIXME: Should be u2[x][y] = ...
                let newValue: Float = 2 * currentWaterLevel[x, y] + (c * c * dt * dt + c * a * dt) * currentWaterLevel.laplace(x, y) * Float(resolution * resolution) - previousWaterLevel[x, y] - c * a * dt * previousWaterLevel.laplace(x, y) * Float(resolution * resolution)
                newWaterLevel[x, y] = newValue
            }
        }

        return Self(currentWaterLevel: newWaterLevel, previousWaterLevel: currentWaterLevel, time: time + dt)
    }
}

