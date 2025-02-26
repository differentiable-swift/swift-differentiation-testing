import _Differentiation

// https://github.com/swiftlang/swift/issues/54819
// Regression due to rewrite of curry thunks.

// TF-688: Test generic curry thunk cloning.
public struct TF_688_Struct<Scalar> {
  var x: Scalar
}
extension TF_688_Struct: Differentiable where Scalar: Differentiable {
  @differentiable(reverse)
  public static func id(x: Self) -> Self {
    return x
  }
}
@differentiable(reverse, wrt: x)
public func TF_688<Scalar: Differentiable>(
  _ x: TF_688_Struct<Scalar>,
  reduction: @differentiable(reverse) (TF_688_Struct<Scalar>) -> TF_688_Struct<Scalar> = TF_688_Struct.id
) -> TF_688_Struct<Scalar> {
  reduction(x)
}
