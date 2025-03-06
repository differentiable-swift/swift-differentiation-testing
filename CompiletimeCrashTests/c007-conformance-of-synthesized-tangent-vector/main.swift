// https://github.com/swiftlang/swift/issues/54898
// `TangentVector` cannot be extended and hence protocol conformance cannot be specified for them.

import _Differentiation

public protocol P {}

public struct S: Differentiable {
    var x: Float = 0
    public init() {}

    //public struct TangentVector: AdditiveArithmetic, Differentiable {
    //  var x: Float = 0
    //}
    //public func move(along direction: TangentVector) { fatalError() }
}

// Tangent vector cannot be extended...
extension S.TangentVector: P {}

func f<T: Differentiable>(_ t: T) where T.TangentVector: P {}

// ... and hence does not conform to this type
f(S())

/*
// Original reproducer unedited: https://github.com/swiftlang/swift/issues/54898
public protocol P {}

public struct S: Differentiable {
  var x: Float = 0
  public init() {}

  //public struct TangentVector: AdditiveArithmetic, Differentiable {
  //  var x: Float = 0
  //}
  //public func move(along direction: TangentVector) { fatalError() }
}

extension S.TangentVector: P {}

func f<T: Differentiable>(_ t: T) where T.TangentVector: P {}

f(S())
*/
