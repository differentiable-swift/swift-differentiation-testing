import _Differentiation
import Foundation

struct Solution: Differentiable {
    var currentWaterLevel: Array2DStorage<Float>
    var previousWaterLevel: Array2DStorage<Float>
    @noDerivative
    var time: Float

    /// Speed of sound
    @noDerivative
    let c: Float = 340.0
    /// Dispersion coefficient
    @noDerivative
    let a: Float = 0.00001
    /// Number of spatial grid points
    @noDerivative
    let resolution: Int
    /// Spatial discretization step
    @noDerivative
    var dx: Float { 1 / Float(resolution) }
    /// Time-step calculated to stay below the CFL stability limit
    @noDerivative
    var dt: Float { (sqrt(a * a + dx * dx / 3) - a) / c }

    @differentiable(reverse)
    init(currentWaterLevel: Array2DStorage<Float>, previousWaterLevel: Array2DStorage<Float>, time: Float) {
        self.currentWaterLevel = currentWaterLevel
        self.previousWaterLevel = previousWaterLevel
        self.time = time
        self.resolution = currentWaterLevel.width
    }

    @differentiable(reverse)
    init(waterLevel: Array2DStorage<Float>, time: Float = 0.0) {
        self.resolution = waterLevel.width
        self.currentWaterLevel = waterLevel
        self.previousWaterLevel = waterLevel
        self.time = time
    }
    
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
    
    static func optimization(
        target: Array2DStorage<Float>,
        resolution: Int,
        duration: Int,
        iterations: Int
    ) -> Array2DStorage<Float> {
        var initialWaterLevel = Array2DStorage<Float>(repeating: 0, width: resolution, height: resolution)

        for opt in 1 ... iterations {
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
        }

        return initialWaterLevel
    }
}

extension Array where Element == Solution {
    @differentiable(reverse)
    init(evolve initialSolution: Solution, for numSteps: Int) {
        self.init()

        var currentSolution = initialSolution
        for step in 0 ..< numSteps {
//            Signpost.default.begin("timestep")

            // TODO: remove from derivative?
            self.append(currentSolution)
            currentSolution = currentSolution.evolve()

//            Signpost.default.end("timestep")
        }
        // TODO: remove from derivative
        self.append(currentSolution)
    }
}

