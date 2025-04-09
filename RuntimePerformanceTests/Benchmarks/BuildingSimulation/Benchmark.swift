import Benchmark

let benchmarks: @Sendable () -> Void = {
    Benchmark("noop", configuration: .init(metrics: [.wallClock, .mallocCountTotal])) { benchmark in
        let x: Int = 42
        blackHole(x)
    }
}
