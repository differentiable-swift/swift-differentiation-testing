import _Differentiation
import Gen
import Testing
import ValidationTesting

@Suite("Operator Tests")
struct OperatorTests {
    @Test func addition() throws {
        let vwpb = valueWithPullback(at: 2.0, 1.0, of: +)
        #expect(vwpb.value == 3.0)
        #expect(vwpb.pullback(1.0) == (1.0, 1.0))
    }
    
    @Test func substraction() throws {
        let vwpb = valueWithPullback(at: 2.0, 1.0, of: -)
        #expect(vwpb.value == 1.0)
        #expect(vwpb.pullback(1.0) == (1.0, -1.0))
    }
    
    @Test func multiplication() throws {
        let vwpb = valueWithPullback(at: 2.0, 3.0, of: *)
        #expect(vwpb.value == 6.0)
        #expect(vwpb.pullback(1.0) == (3.0, 2.0))
    }
    
    @Test func division() throws {
        let vwpb = valueWithPullback(at: 2.0, 4.0, of: /)
        #expect(vwpb.value == 0.5)
        #expect(vwpb.pullback(1.0) == (0.25, -0.125))
    }
}
