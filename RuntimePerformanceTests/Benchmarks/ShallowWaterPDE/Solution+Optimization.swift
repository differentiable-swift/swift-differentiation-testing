import _Differentiation

extension Solution {
    static func optimization(
        target: Array2DStorage<Float>,
        resolution: Int,
        duration: Int,
        iterations: Int
    ) -> Array2DStorage<Float> {
        var initialWaterLevel = Array2DStorage<Float>(repeating: 0, width: resolution, height: resolution)

        for opt in 1 ... iterations {
//            Signpost.default.begin("iteration")

            var (loss, deltaInitialWaterLevel) = valueWithGradient(at: initialWaterLevel) {
                initialWaterLevel -> Float in
                let initialSolution = Solution(waterLevel: initialWaterLevel)
                // TODO: we can save memory here by not keeping all the in between solutions
                let evolution = [Solution](evolve: initialSolution, for: duration)

                let last = withoutDerivative(at: evolution.count - 1)
                let lastEvo = evolution[last].currentWaterLevel
                let loss = lastEvo.meanSquaredError(to: target)
                return loss
            }
            deltaInitialWaterLevel.scale(by: -2)
            initialWaterLevel.move(by: deltaInitialWaterLevel)

//            Signpost.default.end("iteration")
        }

        return initialWaterLevel
    }
}
