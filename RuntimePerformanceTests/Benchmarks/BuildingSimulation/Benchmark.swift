import Benchmark
import _Differentiation

let benchmarks: @Sendable () -> Void = {
    Benchmark(
        "BuildingSimulation - forward",
        configuration: .init(metrics: [.wallClock, .mallocCountTotal])
    ) { benchmark in
        var simParams = SimParams(startingTemp: 33.3)
        benchmark.startMeasurement()
        blackHole(fullPipe(simParams: simParams))
    }

    Benchmark(
        "BuildingSimulation - gradient",
        configuration: .init(metrics: [.wallClock, .mallocCountTotal])
    ) {benchmark in
        var simParams = SimParams(startingTemp: 33.3)
        benchmark.startMeasurement()
        blackHole(gradient(at: simParams, of: { fullPipe(simParams: $0) } ))
    }

}
