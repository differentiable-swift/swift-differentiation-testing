// https://github.com/swiftlang/swift/issues/54721

import _Differentiation

public protocol TensorView {
    associatedtype Element
}
public protocol DifferentiableTensorView: TensorView & Differentiable where Self == TangentVector {}

public protocol PlatformAPI {
    @differentiable
    func abs<T>(_ x: T) -> T where T: DifferentiableTensorView, T.Element: Numeric
}
public class CpuService: PlatformAPI {
  @differentiable
  public func abs<T>(_ x: T) -> T where T: DifferentiableTensorView, T.Element: Numeric { x }
}

public final class Platform {
    public static var service: PlatformAPI = CpuService()
}

@differentiable(where T: DifferentiableTensorView)
public func abs<T: DifferentiableTensorView>(_ x: T) -> T where T.Element: Numeric {
  Platform.service.abs(x)
}
