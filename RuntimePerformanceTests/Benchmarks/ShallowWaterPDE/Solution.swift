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
