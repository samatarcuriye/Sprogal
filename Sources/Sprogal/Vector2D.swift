




public struct Vector2D {
    
    
    
    
    
    public let dx: Scalar
    
    
    
    
    
    public let dy: Scalar
    
    
    
    
    
    public init(dx: Scalar, dy: Scalar) {
        self.dx = dx
        self.dy = dy
    }
    
    
    
    
    
}





extension Vector2D {
    
    
    
    
    
    public static func * (lhs: Scalar, rhs: Vector2D) -> Vector2D {
        return Vector2D(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    
    
    
    
    
    public static func * (lhs: Vector2D, rhs: Scalar) -> Vector2D {
        return rhs * lhs
    }
    
    
    
    
    
    public static func / (lhs: Vector2D, rhs: Scalar) -> Vector2D {
        return Vector2D(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }
    
    
    
    
    
    public static func *= (lhs: inout Vector2D, rhs: Scalar) {
        return lhs = lhs * rhs
    }
    
    
    
    
    
    public static func /= (lhs: inout Vector2D, rhs: Scalar) {
        return lhs = lhs / rhs
    }
    
    
    
    
    
    public static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(dx: -vector.dx, dy: -vector.dy)
    }
    
    
    
    
    
}





extension Vector2D {
    
    
    
    
    
    public static func + (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        return Vector2D(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    
    
    
    
    public static func - (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        return Vector2D(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    
    
    
    
    public static func += (lhs: inout Vector2D, rhs: Vector2D) {
        return lhs = lhs + rhs
    }
    
    
    
    
    
    public static func -= (lhs: inout Vector2D, rhs: Vector2D) {
        return lhs = lhs - rhs
    }
    
    
    
    
    
}

