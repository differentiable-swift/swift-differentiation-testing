import Benchmark

let benchmarks: @Sendable () -> Void = {
    Benchmark("ShallowWaterPDE", configuration: .init(metrics: [.wallClock, .mallocCountTotal])) { benchmark in
        let resolution = 50
        let duration = 10
        let iterations = 10
        let target = Array2DStorage<Float>.loadTarget(target: Resources.swiftLogo.url, resolution: resolution)
        
        benchmark.startMeasurement()
        let optimizedInitialConditions = Solution.optimization(
            target: target,
            resolution: resolution,
            duration: duration,
            iterations: iterations
        )
        benchmark.stopMeasurement()
        
        blackHole(optimizedInitialConditions)
    }
}
