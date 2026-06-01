import Foundation





// MARK: - Declaration

/// An axis-aligned rectangle defined by an origin point and a size.
public struct Rect {
    
    
    
    
    
    /// The bottom-left corner of the rectangle.
    public let origin: Point
    
    
    
    
    
    /// The dimensions of the rectangle.
    public let size: Size
    
    
    
    
    
    /// Creates a rectangle with the given origin and size.
    /// - Parameters:
    ///   - origin: The bottom-left corner. Defaults to `(0, 0)`.
    ///   - size: The dimensions of the rectangle.
    public init(origin: Point = Point(x: 0, y: 0), size: Size) {
        self.origin = origin
        self.size = size
    }
    
    
    
    
    
    /// Creates a rectangle centered at the given point with the given size.
    /// - Parameters:
    ///   - center: The center point of the rectangle.
    ///   - size: The dimensions of the rectangle.
    public init(center: Point, size: Size) {
        self.origin = Point(
            x: center.x - size.width * 0.5,
            y: center.y - size.height * 0.5
        )
        self.size = size
    }
    
    
    
    
    
    /// Creates the smallest axis-aligned rectangle that contains all the given points.
    /// - Parameter points: The points to enclose.
    public init(containing points: [Point]) {
        let xs = points.map { $0.x.value }
        let ys = points.map { $0.y.value }
        
        let minX = xs.min() ?? 0
        let minY = ys.min() ?? 0
        let maxX = xs.max() ?? 0
        let maxY = ys.max() ?? 0
        
        self.origin = Point(x: Scalar(minX), y: Scalar(minY))
        self.size = Size(width: Scalar(maxX - minX), height: Scalar(maxY - minY))
    }
    
    
    
    
    
}





// MARK: - Extremes

/// Accessors for the rectangle's minimum and maximum coordinates.
extension Rect {
    
    
    
    
    
    /// The minimum x-coordinate (left edge).
    public var minX: Scalar {
        return self.origin.x
    }
    
    
    
    
    
    /// The minimum y-coordinate (bottom edge).
    public var minY: Scalar {
        return self.origin.y
    }
    
    
    
    
    
    /// The maximum x-coordinate (right edge).
    public var maxX: Scalar {
        return self.origin.x + self.size.width
    }
    
    
    
    
    
    /// The maximum y-coordinate (top edge).
    public var maxY: Scalar {
        return self.origin.y + self.size.height
    }
    
    
    
    
    
}





// MARK: - Corners

/// Accessors for the rectangle's corner points.
extension Rect {
    
    
    
    
    
    /// The four corner points of the rectangle, starting from the origin
    /// and proceeding clockwise: bottom-left, bottom-right, top-right, top-left.
    public var corners: [Point] {
        return [self.bottomLeft, self.bottomRight, self.topRight, self.topLeft]
    }
    
    
    
    
    
    /// The bottom-left corner of the rectangle.
    public var bottomLeft: Point {
        return self.origin
    }
    
    
    
    
    
    /// The bottom-right corner of the rectangle.
    public var bottomRight: Point {
        return Point(x: self.origin.x + self.size.width, y: self.origin.y)
    }
    
    
    
    
    
    /// The top-left corner of the rectangle.
    public var topLeft: Point {
        return Point(x: self.origin.x, y: self.origin.y + self.size.height)
    }
    
    
    
    
    
    /// The top-right corner of the rectangle.
    public var topRight: Point {
        return Point(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height)
    }
    
    
    
    
    
}





// MARK: - Edges

/// Edge midpoint and center point accessors.
extension Rect {
    
    
    
    
    
    /// The center point of the rectangle.
    public var center: Point {
        return Point(
            x: self.origin.x + self.size.width * 0.5,
            y: self.origin.y + self.size.height * 0.5
        )
    }
    
    
    
    
    
    /// The midpoint of the top edge.
    public var top: Point {
        return Point(
            x: self.origin.x + self.size.width * 0.5,
            y: self.origin.y + self.size.height
        )
    }
    
    
    
    
    
    /// The midpoint of the bottom edge.
    public var bottom: Point {
        return Point(
            x: self.origin.x + self.size.width * 0.5,
            y: self.origin.y
        )
    }
    
    
    
    
    
    /// The midpoint of the left edge.
    public var left: Point {
        return Point(
            x: self.origin.x,
            y: self.origin.y + self.size.height * 0.5
        )
    }
    
    
    
    
    
    /// The midpoint of the right edge.
    public var right: Point {
        return Point(
            x: self.origin.x + self.size.width,
            y: self.origin.y + self.size.height * 0.5
        )
    }
    
    
    
    
    
}





// MARK: - Containment

/// Methods for testing whether points or rectangles are contained.
extension Rect {
    
    
    
    
    
    /// Returns whether this rectangle contains the given point.
    /// - Parameter point: The point to test.
    /// - Returns: `true` if the point is inside the rectangle.
    public func contains(_ point: Point) -> Bool {
        return point.x >= self.minX
            && point.x <= self.maxX
            && point.y >= self.minY
            && point.y <= self.maxY
    }
    
    
    
    
    
    /// Returns whether this rectangle intersects another rectangle.
    /// - Parameter other: The rectangle to test against.
    /// - Returns: `true` if the rectangles overlap.
    public func intersects(_ other: Rect) -> Bool {
        let noOverlap = other.maxX < self.minX
            || other.minX > self.maxX
            || other.maxY < self.minY
            || other.minY > self.maxY
        return !noOverlap
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two rectangles.
extension Rect: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated rectangle between two rectangles.
    /// - Parameters:
    ///   - start: The rectangle at progress `0`.
    ///   - end: The rectangle at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated rectangle.
    public static func interpolate(from start: Rect, to end: Rect, progress: Scalar) -> Rect {
        return Rect(
            origin: Point.interpolate(from: start.origin, to: end.origin, progress: progress),
            size: Size.interpolate(from: start.size, to: end.size, progress: progress)
        )
    }
    
    
    
    
    
}

