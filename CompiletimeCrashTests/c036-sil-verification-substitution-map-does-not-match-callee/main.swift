import _Differentiation

@derivative(of: zip)
@inlinable
public func _vjpZip<Sequence1, Sequence2>(
  _ sequence1: Sequence1, _ sequence2: Sequence2
) -> (value: Zip2Sequence<Sequence1, Sequence2>, pullback: (Zip2Sequence<Sequence1, Sequence2>.TangentVector) -> (Sequence1.TangentVector, Sequence2.TangentVector)) where Sequence1: Differentiable, Sequence2: Differentiable {
    (
        value: zip(sequence1, sequence2),
        pullback: { v in
            return (v.sequence1, v.sequence2)
        }
    )
}

extension Zip2Sequence: @retroactive Differentiable where
    Sequence1: Differentiable & RangeReplaceableCollection,
    Sequence2: Differentiable & RangeReplaceableCollection,
    Sequence1.Element: Differentiable,
    Sequence2.Element: Differentiable,
    Sequence1.TangentVector: RangeReplaceableCollection,
    Sequence2.TangentVector: RangeReplaceableCollection,
    Sequence1.TangentVector.Element == Sequence1.Element.TangentVector,
    Sequence2.TangentVector.Element == Sequence2.Element.TangentVector
{
    @inlinable
    public mutating func move(by offset: TangentVector) {
        var result1 = Sequence1()
        var result2 = Sequence2()
        for (original, offset) in zip(self, offset) {
            var original = original
            original.0.move(by: offset.0)
            original.1.move(by: offset.1)
            result1.append(original.0)
            result2.append(original.1)
        }
        self = zip(result1, result2)
    }
    @inlinable
    public func differentiableMap<Result: Differentiable>(_ transform: @differentiable(reverse) (Sequence1.Element, Sequence2.Element) -> Result) -> [Result] {
        self.map(transform)
    }
    @derivative(of: differentiableMap)
    @inlinable
    public func _vjpDifferentiableMap<Result: Differentiable>(_ transform: @differentiable(reverse) (Sequence1.Element, Sequence2.Element) -> Result) -> (value: [Result], pullback: ([Result].TangentVector) -> Zip2Sequence.TangentVector) {
        var results: [Result] = []
        var pullbacks: [(Result.TangentVector) -> (Sequence1.Element.TangentVector, Sequence2.Element.TangentVector)] = []
        for pair in self {
            let (value, pullback) = valueWithPullback(at: pair.0, pair.1, of: transform)
            results.append(value)
            pullbacks.append(pullback)
        }
        return (
            value: results,
            pullback: { v in
                var results1 = Sequence1.TangentVector()
                results1.reserveCapacity(v.count)
                var results2 = Sequence2.TangentVector()
                results2.reserveCapacity(v.count)
                for (tangentElement, pullback) in zip(v, pullbacks) {
                    let (result1, result2) = pullback(tangentElement)
                    results1.append(result1)
                    results2.append(result2)
                }
                return TangentVector(results1, results2)
            }
        )
    }
}

extension Zip2Sequence {
    public struct TangentVector: Sequence & Differentiable & AdditiveArithmetic where Sequence1: Differentiable, Sequence2: Differentiable, Sequence1.TangentVector: Sequence, Sequence2.TangentVector: Sequence {
        public typealias TangentVector = Self
        public typealias Element = (Sequence1.TangentVector.Element, Sequence2.TangentVector.Element)
        @usableFromInline
        var sequence1: Sequence1.TangentVector
        @usableFromInline
        var sequence2: Sequence2.TangentVector

        @inlinable
        init(_ sequence1: Sequence1.TangentVector, _ sequence2: Sequence2.TangentVector) {
            self.sequence1 = sequence1
            self.sequence2 = sequence2
        }
        @inlinable
        public __consuming func makeIterator() -> Iterator {
            Iterator(baseStream1: sequence1.makeIterator(), baseStream2: sequence2.makeIterator())
        }
        @inlinable
        public var underestimatedCount: Int {
            return Swift.min(
                sequence1.underestimatedCount,
                sequence2.underestimatedCount
            )
        }
        public struct Iterator: IteratorProtocol {
            public typealias Element = (Sequence1.TangentVector.Element, Sequence2.TangentVector.Element)
            @usableFromInline
            var baseStream1: Sequence1.TangentVector.Iterator
            @usableFromInline
            var baseStream2: Sequence2.TangentVector.Iterator
            @usableFromInline
            var reachedEnd: Bool = false
            @inlinable
            init(baseStream1: Sequence1.TangentVector.Iterator, baseStream2: Sequence2.TangentVector.Iterator) {
                self.baseStream1 = baseStream1
                self.baseStream2 = baseStream2
            }
            @inlinable
            public mutating func next() -> (Sequence1.TangentVector.Element, Sequence2.TangentVector.Element)? {
                if reachedEnd {
                    return nil
                }

                guard let element1 = baseStream1.next(),
                      let element2 = baseStream2.next() else {
                    reachedEnd = true
                    return nil
                }

                return (element1, element2)
            }
        }
    }
}

extension Array.DifferentiableView:
    @retroactive Sequence,
    @retroactive Collection,
    @retroactive RangeReplaceableCollection,
    @retroactive RandomAccessCollection,
    @retroactive BidirectionalCollection,
    @retroactive MutableCollection
    where Element: Differentiable
{
    public typealias Element = Array.Element
    public typealias Index = Array.Index
    public typealias SubSequence = Array.SubSequence

    @inlinable
    public subscript(position: Index) -> Element {
        _read { yield base[position] }
        set(newValue) { base[position] = newValue }
    }

    @inlinable
    public subscript(bounds: Range<Index>) -> SubSequence {
        get { base[bounds] }
        set(newValue) { base[bounds] = newValue }
    }

    @inlinable
    public var startIndex: Index { base.startIndex }

    @inlinable
    public var endIndex: Index { base.endIndex }

    @inlinable
    public init() { self.init(Array<Element>()) }

    @inlinable
    public mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C)
        where C: Collection, Self.Element == C.Element
    {
        base.replaceSubrange(subrange, with: newElements)
    }
}
