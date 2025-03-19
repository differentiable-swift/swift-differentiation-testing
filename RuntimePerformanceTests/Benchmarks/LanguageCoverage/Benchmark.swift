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
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = oneOperation(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in oneOperation(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "sixteen operations",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = sixteenOperations(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in sixteenOperations(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "two composed operations",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = twoComposedOperations(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in twoComposedOperations(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "sixteen composed operations",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = sixteenComposedOperations(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in sixteenComposedOperations(a: v) })
            }
            blackHole(x)
        }
    )
    
    // Functions with loops.
    
    Benchmark(
        "one operation looped (small)",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = oneOperationLoopedSmall(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in oneOperationLoopedSmall(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "four operations looped (small)",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = fourOperationsLoopedSmall(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in fourOperationsLoopedSmall(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "sixteen operations looped (small)",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = sixteenOperationsLoopedSmall(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in sixteenOperationsLoopedSmall(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "one operation looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = oneOperationLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in oneOperationLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "two operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = twoOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in twoOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "four operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = fourOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in fourOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "eight operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = eightOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in eightOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "sixteen operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = sixteenOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in sixteenOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "two composed operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = twoComposedOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in twoComposedOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )
    Benchmark(
        "sixteen composed operations looped",
        forward: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = sixteenComposedOperationsLooped(a: x)
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var x: Float = 2.0
            clobber(&x)
            for _ in benchmark.scaledIterations {
                x = gradient(at: x, of: { v in sixteenComposedOperationsLooped(a: v) })
            }
            blackHole(x)
        }
    )

    // Arithmetic and control flow functions generated by a fuzzer.

    Benchmark(
        "fuzzed arithmetic 1",
        forward: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = fuzzedMath1(x, y, z)
                y += x
                z += x
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                (x, y, z) = gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMath1(x, y, z) })
            }
            benchmark.stopMeasurement()
            blackHole(x); blackHole(y); blackHole(z)
        }
    )
    Benchmark(
        "fuzzed arithmetic 2",
        forward: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = fuzzedMath2(x, y, z)
                y += x
                z += x
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                (x, y, z) = gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMath2(x, y, z) })
            }
            benchmark.stopMeasurement()
            blackHole(x); blackHole(y); blackHole(z)
        }
    )

    Benchmark(
        "fuzzed arithmetic with ternary operators 1",
        forward: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = fuzzedMathTernary1(x, y, z)
                y += x
                z += x
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                (x, y, z) = gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMathTernary1(x, y, z) })
            }
            benchmark.stopMeasurement()
            blackHole(x); blackHole(y); blackHole(z)
        }
    )
    Benchmark(
        "fuzzed arithmetic with ternary operators 2",
        forward: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                x = fuzzedMathTernary2(x, y, z)
                y += x
                z += x
            }
            blackHole(x)
        },
        reverse: { benchmark in
            var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
            clobber(&x); clobber(&y); clobber(&z)
            benchmark.startMeasurement()
            for _ in benchmark.scaledIterations {
                (x, y, z) = gradient(at: 1.0, 2.0, 3.0, of: { x, y, z in fuzzedMathTernary2(x, y, z) })
            }
            benchmark.stopMeasurement()
            blackHole(x); blackHole(y); blackHole(z)
        }
    )
}
