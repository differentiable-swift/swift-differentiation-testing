// RUN: swiftc main.swift -o main 2>&1 | ../check.py check
import _Differentiation

// https://github.com/swiftlang/swift/issues/57523
// Need to add a new diagnostic in order to avoid crash when a throwing function is used within `gradient`.

enum E: Error {
    case error
}

@differentiable(reverse)
func f(x: Double) throws -> Double {
    if x < 0 {
        throw E.error
    } else {
        return x * x
    }
}

print(gradient(at: 2.0, of: { x in try! f(x: x) }))
