




public struct Vector {
    
    
    
    
    
    public let x: Scalar
    
    
    
    
    
    public let y: Scalar
    
    
    
    
    
    
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    
    
    
    
}





extension Vector: Sendable {}





extension Vector: CustomStringConvertible {
    
    
    
    
    
    public var description: String {
        return "(\(x), \(y))"
    }
    
    
    
    
    
}





extension Vector {
    
    
    
    
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    
    
    
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    
    
    
    
}





extension Vector {
    
    
    
    
    
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        return Vector(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    
    
    
    
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        return Vector(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    
    
    
    
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        return Vector(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    
    
    
    
}





extension Vector {
    
    
    
    
    
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    
    
    
    
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    
    
    
    
    public static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
    
    
    
    
    
    public static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
    
    
    
    
    
}





extension Vector {
    
    
    
    
    
    
    public func dot(_ other: Self) -> Scalar {
        return self.x * other.x + self.y * other.y
    }
    
    
    
    
    
    public var lengthSquared: Scalar {
        return self.dot(self)
    }
    
    
    
    
    
    public var length: Scalar {
        return self.lengthSquared.squareRoot()
    }
    
    
    
    
    
    public var normalized: Self {
        return self.length == 0 ? Vector.zero: self / self.length
    }
    
    
    
    
    
}





extension Vector {
    
    
    
    
    
    public static let zero = Vector(x: 0, y: 0)
    
    
    
    
    
}
