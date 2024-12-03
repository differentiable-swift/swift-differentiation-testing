import Foundation
import Gen
import Testing
import ValidationTesting

@Suite("TGMath Derivatives")
struct TGMathDerivativesTests {
    @Test(arguments: Gen.double(in: 0...10000).array(of: .always(100)).run())
    func testSqrt(_ x: Double) {
        validateVJP(
            of: { x in sqrt(x) },
            with: { x in (sqrt(x), { v in v / (2 * sqrt(x)) } ) },
            at: x
        )
    }
}
