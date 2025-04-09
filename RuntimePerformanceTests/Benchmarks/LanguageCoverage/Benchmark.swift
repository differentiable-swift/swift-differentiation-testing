import Benchmark
import Foundation
import _Differentiation

let benchmarks: @Sendable () -> Void = {
    // - MARK: Simple functions.
    // MARK: one operation
    
    Benchmark("one operation", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = oneOperation(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("one operation", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in oneOperation(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("one operation", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in oneOperation(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: sixteen operations
    
    Benchmark("sixteen operations", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = sixteenOperations(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operation", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in sixteenOperations(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operation", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in sixteenOperations(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: two composed operations
    
    Benchmark("two composed operations", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = twoComposedOperations(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("two composed operation", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in twoComposedOperations(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("two composed operation", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in twoComposedOperations(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: sixteen composed operations

    Benchmark("sixteen composed operations", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = sixteenComposedOperations(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("sixteen composed operation", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in sixteenComposedOperations(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("sixteen composed operation", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in sixteenComposedOperations(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: - Functions with loops.
    // MARK: one operation looped (small)
    
    Benchmark("one operation looped (small)", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = oneOperationLoopedSmall(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("one operation looped (small)", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in oneOperationLoopedSmall(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("one operation looped (small)", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in oneOperationLoopedSmall(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: four operations looped (small)
    
    Benchmark("four operation looped (small)", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fourOperationsLoopedSmall(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("four operation looped (small)", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in fourOperationsLoopedSmall(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("four operation looped (small)", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in fourOperationsLoopedSmall(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: sixteen operations looped (small)
    
    Benchmark("sixteen operation looped (small)", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = sixteenOperationsLoopedSmall(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operation looped (small)", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in sixteenOperationsLoopedSmall(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operation looped (small)", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in sixteenOperationsLoopedSmall(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: one operation looped
    
    Benchmark("one operation looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = oneOperationLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("one operation looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in oneOperationLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("one operation looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in oneOperationLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: two operations looped
    
    Benchmark("two operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = twoOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("two operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in twoOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("two operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in twoOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: four operations looped
    
    Benchmark("four operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fourOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("four operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in fourOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("four operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in fourOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: eight operations looped
    
    Benchmark("eight operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = eightOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("eight operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in eightOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("eight operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in eightOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: sixteen operations looped
    
    Benchmark("sixteen operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = sixteenOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in sixteenOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("sixteen operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in sixteenOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: two composed operations looped
    
    Benchmark("two composed operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = twoComposedOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("two composed operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in twoComposedOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("two composed operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in twoComposedOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }
    
    // MARK: sixteen composed operations looped
    
    Benchmark("sixteen composed operations looped", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = sixteenComposedOperationsLooped(a: x)
        }
        blackHole(x)
    }
    
    Benchmark("sixteen composed operations looped", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var x: Float = 2.0
        clobber(&x)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, of: { v in sixteenComposedOperationsLooped(a: v) }).value
        }
        blackHole(x)
    }
    
    Benchmark("sixteen composed operations looped", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var vx: Float = 1.0
        clobber(&vx)
        let pullback = valueWithPullback(at: 2.0, of: { v in sixteenComposedOperationsLooped(a: v) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            vx = pullback(vx)
        }
        blackHole(vx)
    }

    // MARK: - Arithmetic and control flow functions generated by a fuzzer.
    // MARK: fuzzed arithmetic 1
    
    Benchmark("fuzzed arithmetic 1", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fuzzedMath1(x, y, z)
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic 1", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)

        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, y, z, of: { vx, vy, vz in fuzzedMath1(vx, vy, vz) }).value
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic 1", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var v: Float = 1.0
        var (vx, vy, vz): (Float, Float, Float) = (1.0, 1.0, 1.0)
        clobber(&v)
        
        let pullback = valueWithPullback(at: 1.0, 2.0, 3.0, of: { vx, vy, vz in fuzzedMath1(vx, vy, vz) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            (vx, vy, vz) = pullback(v)
            v += vx + vy + vz
        }
        blackHole(v)
    }
    
    // MARK: fuzzed arithmetic 2
    
    Benchmark("fuzzed arithmetic 2", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fuzzedMath2(x, y, z)
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic 2", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)

        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, y, z, of: { vx, vy, vz in fuzzedMath2(vx, vy, vz) }).value
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic 2", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var v: Float = 1.0
        var (vx, vy, vz): (Float, Float, Float) = (1.0, 1.0, 1.0)
        clobber(&v)
        
        let pullback = valueWithPullback(at: 1.0, 2.0, 3.0, of: { vx, vy, vz in fuzzedMath2(vx, vy, vz) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            (vx, vy, vz) = pullback(v)
            v += vx + vy + vz
        }
        blackHole(v)
    }
    
    // MARK: fuzzed arithmetic with ternary operators 1
    
    Benchmark("fuzzed arithmetic with ternary operators 1", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fuzzedMathTernary1(x, y, z)
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic with ternary operators 1", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)

        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, y, z, of: { vx, vy, vz in fuzzedMathTernary1(vx, vy, vz) }).value
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic with ternary operators 1", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var v: Float = 1.0
        var (vx, vy, vz): (Float, Float, Float) = (1.0, 1.0, 1.0)
        clobber(&v)
        
        let pullback = valueWithPullback(at: 1.0, 2.0, 3.0, of: { vx, vy, vz in fuzzedMathTernary1(vx, vy, vz) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            (vx, vy, vz) = pullback(v)
            v += vx + vy + vz
        }
        blackHole(v)
    }

    // MARK: fuzzed arithmetic with ternary operators 2
    
    Benchmark("fuzzed arithmetic with ternary operators 2", configuration: .init(tags: ["pass": "regular"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = fuzzedMathTernary2(x, y, z)
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic with ternary operators 2", configuration: .init(tags: ["pass": "forward"])) { benchmark in
        var (x, y, z): (Float, Float, Float) = (1.0, 2.0, 3.0)
        clobber(&x); clobber(&y); clobber(&z)

        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            x = valueWithPullback(at: x, y, z, of: { vx, vy, vz in fuzzedMathTernary2(vx, vy, vz) }).value
            y += x
            z += x
        }
        benchmark.stopMeasurement()
        blackHole(x); blackHole(y); blackHole(z)
    }
    
    Benchmark("fuzzed arithmetic with ternary operators 2", configuration: .init(tags: ["pass": "reverse"])) { benchmark in
        var v: Float = 1.0
        var (vx, vy, vz): (Float, Float, Float) = (1.0, 1.0, 1.0)
        clobber(&v)
        
        let pullback = valueWithPullback(at: 1.0, 2.0, 3.0, of: { vx, vy, vz in fuzzedMathTernary2(vx, vy, vz) }).pullback
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            (vx, vy, vz) = pullback(v)
            v += vx + vy + vz
        }
        blackHole(v)
    }
}
