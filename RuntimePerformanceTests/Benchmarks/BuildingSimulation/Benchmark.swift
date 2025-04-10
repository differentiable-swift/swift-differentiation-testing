import Benchmark
import _Differentiation

let benchmarks: @Sendable () -> Void = {
    Benchmark(
        "BuildingSimulation",
        configuration: .init(tags: ["pass": "regular"])
    ) { benchmark in
        let simParams = SimParams(startingTemp: 33.3)
        benchmark.startMeasurement()
        blackHole(fullPipe(simParams: simParams))
    }

    Benchmark(
        "BuildingSimulation",
        configuration: .init(tags: ["pass": "forward"])
    ) { benchmark in
        let simParams = SimParams(startingTemp: 33.3)
        benchmark.startMeasurement()
        blackHole(valueWithPullback(at: simParams, of: { fullPipe(simParams: $0) }))
    }

    Benchmark(
        "BuildingSimulation",
        configuration: .init(tags: ["pass": "reverse"])
    ) { benchmark in
        let simParams = SimParams(startingTemp: 33.3)
        var temp: Float = 33.3
        clobber(&temp)
        let pullback = valueWithPullback(at: simParams, of: { fullPipe(simParams: $0) }).pullback
        benchmark.startMeasurement()
        blackHole(pullback(temp))
    }
}
