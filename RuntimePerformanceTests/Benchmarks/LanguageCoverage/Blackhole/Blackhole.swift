/// `inout` variant of package-benchmark's `blackHole`.
/// This forces the compiler to assume that `x` is mutated.
/// Can be used to prevent loop-invariant code motion and const-folding.
@_optimize(none)
public func blackHoleInout(_ x: inout some Any) {}

/// Same functionality as `blackHoleInout`, but takes raw pointer instead.
/// Anecdotal evidence suggests that this one produces fewer spurious instructions.
@_optimize(none)
public func clobber(_ x: UnsafeMutableRawPointer) {}
