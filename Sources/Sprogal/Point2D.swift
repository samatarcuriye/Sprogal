




public struct Point2D {
    
    
    
    
    
    public let x: Scalar
    
    
    
    
    
    public let y: Scalar
    
    
    
    
    
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    
    
    
    
}





extension Point2D {
    
    
    
    
    
    public static func + (lhs: Point2D, rhs: Vector2D) -> Point2D {
        return Point2D(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    
    
    
    
    public static func + (lhs: Vector2D, rhs: Point2D) -> Point2D {
        return Point2D(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
    }
    
    
    
    
    
    public static func - (lhs: Point2D, rhs: Point2D) -> Vector2D {
        return Vector2D(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
    
    
    
    
    
}





extension Point2D: Interpolatable {
    
    
    
    
    
    public func interpolated(to other: Point2D, fraction: Scalar) -> Point2D {
        return self + (other - self) * fraction
    }
    
    
    
    
    
}
