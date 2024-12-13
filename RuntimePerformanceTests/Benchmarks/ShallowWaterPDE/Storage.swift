import _Differentiation

struct Array2DStorage<Element> {
    @noDerivative
    var width: Int
    @noDerivative
    var height: Int
    
    var values: [Element]
    
    @inlinable var scalars: [Element] { values }
    
    @inlinable subscript(_ x: Int, _ y: Int) -> Element {
        get { values[x + y * width] }
        set { values[x + y * width] = newValue }
    }
    
    @inlinable
    init(width: Int, height: Int, values: [Element]) {
        assert(values.count == width * height, "values.count (\(values.count)) should equal width * height (\(width * height))")
        self.width = width
        self.height = height
        self.values = values
    }
    
    @inlinable
    func map<T>(
        _ transform: (Element) throws -> T
    ) rethrows -> Array2DStorage<T> {
        .init(width: width, height: height, values: try values.map(transform))
    }
}

extension Array2DStorage {
    @inlinable
    init(repeating element: Element, width: Int, height: Int) {
        self.width = width
        self.height = height
        self.values = .init(repeating: element, count: width * height)
    }
}

extension Array2DStorage: Equatable where Element: Equatable { }

extension Array2DStorage where Element: FloatingPoint {
    @inlinable
    mutating func scale(by scale: Element) {
        self.values = self.values.map { $0 * scale }
    }
}

extension Array2DStorage: AdditiveArithmetic where Element: AdditiveArithmetic {
    static var zero: Array2DStorage<Element> {
        .init(width: 0, height: 0, values: []) // ideally this would require the same size as the value we're adding to or equating with.
    }
    
    static func + (lhs: Array2DStorage<Element>, rhs: Array2DStorage<Element>) -> Array2DStorage<Element> {
        if lhs.values.count == 0 {
            return rhs
        }
        if rhs.values.count == 0 {
            return lhs
        }
        precondition(
            lhs.width == rhs.width && lhs.height == rhs.height,
            "Shape mismatch: (\(lhs.width), \(lhs.height)) and (\(rhs.width), \(rhs.height))"
        )
        return .init(width: lhs.width, height: lhs.height, values: zip(lhs.values, rhs.values).map(+))
    }
    
    @inlinable
    static func - (lhs: Array2DStorage<Element>, rhs: Array2DStorage<Element>) -> Array2DStorage<Element> {
        if lhs.values.count == 0 {
            return rhs
        }
        if rhs.values.count == 0 {
            return lhs
        }
        precondition( // swiftlint:disable:this no_precondition
            lhs.width == rhs.width && lhs.height == rhs.height,
            "Shape mismatch: (\(lhs.width), \(lhs.height)) and (\(rhs.width), \(rhs.height))"
        )
        return .init(width: lhs.width, height: lhs.height, values: zip(lhs.values, rhs.values).map(-))
    }
}

extension Array2DStorage: Differentiable where Element: Differentiable {
    typealias TangentVector = Array2DStorage<Element.TangentVector>
    
    @inlinable
    mutating func move(by offset: TangentVector) {
        if offset.values.isEmpty {
            return
        }
        precondition(
            self.width == offset.width && self.height == offset.height,
            "Shape mismatch: self(\(self.width), \(self.height)) and offset(\(offset.width), \(offset.height))"
        )
        for i in offset.values.indices {
            self.values[i].move(by: offset.values[i])
        }
    }
    
    @derivative(of: subscript.get)
    @inlinable
    func _vjpSubscriptGet(_ x: Int, _ y: Int) -> (value: Element, pullback: (Element.TangentVector) -> TangentVector) {
        let width = self.width
        let height = self.height
        
        return (
            value: self[x, y],
            pullback: { tangentVector in
                var dSelf = Array2DStorage.TangentVector(repeating: .zero, width: width, height: height)
                dSelf.values[x + width * y] = tangentVector
                return dSelf
            }
        )
    }
    
    @derivative(of: subscript.set)
    @inlinable
    mutating func _vjpSubscriptSet(_ newValue: Element, _ x: Int, _ y: Int) -> (value: Void, pullback: (inout TangentVector) -> Element.TangentVector) {
        let width = self.width
        let height = self.height
        let count = self.values.count
        precondition(width * height == count, "invalid array2d (values mismatch widht * height)")
        
        return (
            value: (),
            pullback: { tangentVector in
                precondition(width == tangentVector.width, "width mismatch")
                precondition(height == tangentVector.height, "height mismatch")
                precondition(count == tangentVector.values.count, "values count mismatch")
                let dElement = tangentVector.values[x + y * width]
                tangentVector.values[x + y * width] = .zero
                return dElement
            }
        )
    }
}
