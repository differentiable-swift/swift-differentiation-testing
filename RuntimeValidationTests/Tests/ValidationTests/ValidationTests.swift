import Testing

@Suite("Pipeline validation tests")
struct SanityChecksTests {
    @Test("Test that always passes") func alwaysPass() throws {
        #expect(Bool(true))
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test("Test that always fails") func alwaysFail() throws {
        withKnownIssue {
            #expect(Bool(false))
        }
    }
}
