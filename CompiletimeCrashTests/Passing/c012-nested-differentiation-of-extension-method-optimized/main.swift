// https://github.com/swiftlang/swift/pull/41418/files
import _Differentiation

protocol P {
    @differentiable(reverse)
    func req(_ input: Float) -> Float
}
extension P {
    @differentiable(reverse)
    func foo(_ input: Float) -> Float {
        return req(input)
    }
}
struct Dummy: P {
    @differentiable(reverse)
    func req(_ input: Float) -> Float {
        input
    }
}
