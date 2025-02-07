// ===============================================
// https://github.com/swiftlang/swift/issues/73068
// ===============================================
import Foundation
import OrderedCollections
import _Differentiation

extension OrderedDictionary: Differentiable where Value: Differentiable {
    public typealias TangentVector = OrderedDictionary<Key, Value.TangentVector>
    public mutating func move(by direction: TangentVector) {}
}
extension OrderedDictionary: AdditiveArithmetic where Value: AdditiveArithmetic {
    public static func + (_ lhs: Self, _ rhs: Self) -> Self { fatalError() }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self { fatalError() }
    public static var zero: Self { [:] }
}
struct A<I: Hashable, D: Differentiable>: Differentiable {
    var r: OrderedDictionary<I, OrderedDictionary<String, D>>
    @differentiable(reverse) mutating func i(x: I, v: OrderedDictionary<String, D>) {
        self.r[x] = v
    }
}
