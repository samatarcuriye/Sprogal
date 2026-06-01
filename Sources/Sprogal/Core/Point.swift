import Foundation





// MARK: - Declaration

/// A two-dimensional point in local coordinate space.
public struct Point {
    
    
    
    
    
    /// The horizontal coordinate.
    public let x: Scalar
    
    
    
    
    
    /// The vertical coordinate.
    public let y: Scalar
    
    
    
    
    
    /// Creates a point with the given coordinates.
    /// - Parameters:
    ///   - x: The horizontal coordinate.
    ///   - y: The vertical coordinate.
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    
    
    
    
}





// MARK: - Equatable

/// Equality comparison between points.
extension Point: Equatable {
    
    
    
    
    
    /// Returns a Boolean value indicating whether two points are equal.
    /// - Parameters:
    ///   - lhs: The first point to compare.
    ///   - rhs: The second point to compare.
    /// - Returns: `true` if both points have the same coordinates.
    public static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    
    
    
    
}





// MARK: - Arithmetic

/// Operators for combining points with vectors.
extension Point {
    
    
    
    
    
    /// Offsets a point by a vector.
    /// - Parameters:
    ///   - lhs: The point to offset.
    ///   - rhs: The vector to apply.
    /// - Returns: The offset point.
    public static func + (lhs: Point, rhs: Vector) -> Point {
        return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    
    
    
    
    /// Offsets a point by the negative of a vector.
    /// - Parameters:
    ///   - lhs: The point to offset.
    ///   - rhs: The vector to subtract.
    /// - Returns: The offset point.
    public static func - (lhs: Point, rhs: Vector) -> Point {
        return Point(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
    
    
    
    
    
}





// MARK: - Distance

/// Distance computation between points.
extension Point {
    
    
    
    
    
    /// Computes the Euclidean distance from this point to another.
    /// - Parameter other: The other point.
    /// - Returns: The distance.
    public func distance(to other: Point) -> Scalar {
        let dx = other.x - self.x
        let dy = other.y - self.y
        return sqrt(dx * dx + dy * dy)
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two points.
extension Point: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated point between two points.
    /// - Parameters:
    ///   - start: The point at progress `0`.
    ///   - end: The point at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated point.
    public static func interpolate(from start: Point, to end: Point, progress: Scalar) -> Point {
        return Point(
            x: start.x + (end.x - start.x) * progress,
            y: start.y + (end.y - start.y) * progress
        )
    }
    
    
    
    
    
}

