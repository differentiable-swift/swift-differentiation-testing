import Testing
import ValidationTesting
import _Differentiation

@differentiable(reverse)
func squared(_ x: Double) -> Double {
    x * x
}

func vjpSquaredTruth(_ x: Double) -> (value: Double, pullback: (Double) -> Double) {
    (
        value: x * x,
        pullback: { v in
            2 * x * v
        }
    )
}

func gradientSquaredTruth(_ x: Double) -> Double {
    2 * x
}

// ===============================================
// https://github.com/swiftlang/swift/issues/54685
// ===============================================
class Class: Differentiable {
    @differentiable(reverse)
    var x: Float

    init(_ x: Float) {
        self.x = x
    }
}

@_silgen_name("inout_mutating")
func inoutMutating(_ c: inout Class) {
    // the modify accessor is not active, leading to incorrect derivatives
    c.x *= c.x
}

func squaredClass(_ x: Float) -> Float {
    var c = Class(x)
    inoutMutating(&c)
    return c.x
}

// ===============================================
// https://github.com/swiftlang/swift/issues/54214
// ===============================================
@differentiable(reverse)  // NOTE: This wasn't there in the original reproducer
func tupleElementGeneric<T: Differentiable>(_ x: T, _ y: T) -> [T] {
    // (fixed) Incorrect derivative for array literal with tuple_element_addr elements
    var tuple = (x, y)
    return [tuple.0, tuple.1]
}

// ===============================================
// https://github.com/swiftlang/swift/issues/58070
// ===============================================
extension Double {
    fileprivate func addingThree(_ lhs: Self, _ mhs: Self, _ rhs: Self) -> Self {
        self + lhs + rhs
    }

    @derivative(of: addingThree)
    fileprivate func _vjpAddingThree(
        _ lhs: Self,
        _ mhs: Self,
        _ rhs: Self
    ) -> (value: Self, pullback: (Self) -> (Self, Self, Self, Self)) {
        return (addingThree(lhs, mhs, rhs), { v in (v, lhs, mhs, rhs) })
    }

    fileprivate mutating func addThree(_ lhs: Self, _ mhs: Self, _ rhs: Self) {
        self += lhs + mhs + rhs
    }

    @derivative(of: addThree)
    fileprivate mutating func _vjpAddThree(
        _ lhs: Self,
        _ mhs: Self,
        _ rhs: Self
    ) -> (value: Void, pullback: (inout Self) -> (Self, Self, Self)) {
        addThree(lhs, mhs, rhs)
        return ((), { v in (lhs, mhs, rhs) })
    }
}

@differentiable(reverse)
func altAddingThree(_ x: Double, _ y: Double, _ z: Double, _ w: Double) -> Double {
    var output = x
    output.addThree(y, z, w)
    return output
}

// =========================================================================================================
// https://github.com/swiftlang/swift/blob/main/test/AutoDiff/stdlib/collection_higher_order_functions.swift
// =========================================================================================================

// Test differentiable collection higher order functions:
// `differentiableMap(_:)` and `differentiableReduce(_:_:)`.

let array: [Float] = [1, 2, 3, 4, 5]

func double(_ array: [Float]) -> [Float] {
    array.differentiableMap { $0 * $0 }
}

func product(_ array: [Float]) -> Float {
    array.differentiableReduce(1) { $0 * $1 }
}

@Suite
struct ValidationTestingTests {
    @Test(arguments: [1.0])
    func testVJPValidation(x: Double) {
        validateVJP(
            of: { x in squared(x) },  // we can call the function directly with upcoming compiler fix
            with: vjpSquaredTruth,
            at: x
        )
    }

    @Test(arguments: [1.0])
    func testGradientValidation(x: Double) {
        validateGradient(
            of: { x in squared(x) },  // we can call the function directly with upcoming compiler fix
            with: gradientSquaredTruth,
            at: x
        )
    }

    @Test(arguments: [10.0])
    func testInoutMutating(_ x: Float) {
        // incorrect derivative because modify accessor not active
        withKnownIssue {
            // error: A '@differentiable' function can only be formed from a reference to a 'func', 'init' or a literal closure
            // let result = valueWithGradient(at: x, of: squaredClass)
            let result = valueWithGradient(at: x, of: { v in squaredClass(v) })  // workaround because macros mess with it
            #expect(result.value == 100.0)
            #expect(result.gradient == 20.0)
        }
    }

    @Test
    func testTupleElementPullback() {
        // (fixed) incorrect derivative for array literal with tuple element elements
        let pb = pullback(at: Float(3), 4, of: { tupleElementGeneric($0, $1) })
        #expect((1.0 as Float, 1.0 as Float) == pb(.init([1, 1])))
    }

    @Test(arguments: [(2.0, 3.0, 4.0)])
    func testAddingThree(_ x: Double, y: Double, z: Double) {
        // incorrect results when differentiating a mutating function
        withKnownIssue {
            #expect((2, 3, 4) == gradient(at: 2, 3, 4, of: { 10.addingThree($0, $1, $2) }))
            #expect((2, 3, 4) == gradient(at: 2, 3, 4, of: { altAddingThree(10, $0, $1, $2) }))
        }
    }

    @Test
    func testHigherOrderFunctions() {
        #expect([] == pullback(at: array, of: { double($0) })([]))
        #expect([0] == pullback(at: array, of: { double($0) })([0]))
        #expect([2] == pullback(at: array, of: { double($0) })([1]))
        #expect([2, 4, 6, 8, 10] == pullback(at: array, of: { double($0) })([1, 1, 1, 1, 1]))

        #expect([1] == gradient(at: [0], of: { product($0) }))
        #expect([1] == gradient(at: [1], of: { product($0) }))
        #expect([120, 60, 40, 30, 24] == gradient(at: array, of: { product($0) }))
    }
}
