import Benchmark
import Foundation
import _Differentiation

enum CustomMeasurement {
    static let forward = BenchmarkMetric.custom("run forward (ns)", polarity: .prefersSmaller, useScalingFactor: true)
    static let reverse = BenchmarkMetric.custom("run reverse (ns)", polarity: .prefersSmaller, useScalingFactor: true)
    static let ratio = BenchmarkMetric.custom("ratio", polarity: .prefersSmaller, useScalingFactor: false)
}

extension BenchmarkMetric: @unchecked @retroactive Sendable {}

extension Benchmark {
    @discardableResult
    convenience init?(_ name: String, forward: @escaping (Benchmark) -> (), reverse: @escaping (Benchmark) -> ()) {
        self.init(name, configuration: .init(metrics: [CustomMeasurement.forward, CustomMeasurement.reverse, CustomMeasurement.ratio], warmupIterations: 1, scalingFactor: .kilo)) { benchmark in
            let startForward = BenchmarkClock.now
            forward(benchmark)
            let endForward = BenchmarkClock.now
            let startReverse = BenchmarkClock.now
            reverse(benchmark)
            let endReverse = BenchmarkClock.now
            
            let forward = Int((endForward - startForward).nanoseconds())
            let reverse = Int((endReverse - startReverse).nanoseconds())
            
            benchmark.measurement(CustomMeasurement.forward, forward)
            benchmark.measurement(CustomMeasurement.reverse, reverse)
            benchmark.measurement(CustomMeasurement.ratio, reverse / forward)
        }
    }
}

let benchmarks: @Sendable () -> Void = {
    // Simple functions.
    
    Benchmark(
        "one operation",
        forward: { benchmark in
            var x: Float = 2.0
            for _ in benchmark.scaledIterations {
                x = oneOperation(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var y: Float = 2.0
            for _ in benchmark.scaledIterations {
                y = gradient(at: y, of: { v in oneOperation(a: v) })
            }
            blackHole(y)
        }
    )
    Benchmark(
        "sixteen operations",
        forward: { benchmark in
            var x = Float.random(in: 1.5...2.5)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = sixteenOperations(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var y: Float = 2.0
            for _ in benchmark.scaledIterations {
                y = gradient(at: y, of: { v in sixteenOperations(a: v) })
            }
            blackHole(y)
        }
    )
    Benchmark(
        "two composed operations",
        forward: { benchmark in
            var x: Float = 2.0
            for _ in benchmark.scaledIterations {
                x = twoComposedOperations(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var y: Float = 2.0
            for _ in benchmark.scaledIterations {
                y = gradient(at: y, of: { v in twoComposedOperations(a: v) })
            }
            blackHole(y)
        }
    )
    Benchmark(
        "sixteen composed operations",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenComposedOperations(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in sixteenComposedOperations(a: v) }))
            }
        }
    )
    
    // Functions with loops.
    
    Benchmark(
        "one operation looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(oneOperationLoopedSmall(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in oneOperationLoopedSmall(a: v) }))
            }
        }
    )
    Benchmark(
        "four operations looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fourOperationsLoopedSmall(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in fourOperationsLoopedSmall(a: v) }))
            }
        }
    )
    Benchmark(
        "sixteen operations looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenOperationsLoopedSmall(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in sixteenOperationsLoopedSmall(a: v) }))
            }
        }
    )
    Benchmark(
        "one operation looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(oneOperationLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in oneOperationLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "two operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(twoOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in twoOperationsLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "four operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fourOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in fourOperationsLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "eight operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(eightOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in eightOperationsLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "sixteen operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in sixteenOperationsLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "two composed operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(twoComposedOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in twoComposedOperationsLooped(a: v) }))
            }
        }
    )
    Benchmark(
        "sixteen composed operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenComposedOperationsLooped(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: { v in sixteenComposedOperationsLooped(a: v) }))
            }
        }
    )

    // Arithmetic and control flow functions generated by a fuzzer.

    Benchmark(
        "fuzzed arithmetic 1",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fuzzedMath1(1.0, 2.0, 3.0))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMath1(x, y, z) }))
            }
        }
    )
    Benchmark(
        "fuzzed arithmetic 2",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fuzzedMath2(1.0, 2.0, 3.0))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMath2(x, y, z) }))
            }
        }
    )

    Benchmark(
        "fuzzed arithmetic with ternary operators 1",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fuzzedMathTernary1(1.0, 2.0, 3.0))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMathTernary1(x, y, z) }))
            }
        }
    )
    Benchmark(
        "fuzzed arithmetic with ternary operators 2",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fuzzedMathTernary2(1.0, 2.0, 3.0))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMathTernary2(x, y, z) }))
            }
        }
    )
}
