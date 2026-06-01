import Foundation





// MARK: - Declaration

/// A two-dimensional vector representing a direction and magnitude.
/// Used for offsets, scale factors, and translations in Sprogal.
public struct Vector {
    
    
    
    
    
    /// The horizontal component.
    public let dx: Scalar
    
    
    
    
    
    /// The vertical component.
    public let dy: Scalar
    
    
    
    
    
    /// Creates a vector with the given components.
    /// - Parameters:
    ///   - dx: The horizontal component.
    ///   - dy: The vertical component.
    public init(dx: Scalar, dy: Scalar) {
        self.dx = dx
        self.dy = dy
    }
    
    
    
    
    
}





// MARK: - Arithmetic

/// Arithmetic operators for combining and scaling vectors.
extension Vector {
    
    
    
    
    
    /// Adds two vectors and returns the result.
    /// - Parameters:
    ///   - lhs: The first vector.
    ///   - rhs: The second vector.
    /// - Returns: The sum of the two vectors.
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    
    
    
    
    /// Subtracts the right vector from the left and returns the result.
    /// - Parameters:
    ///   - lhs: The vector to subtract from.
    ///   - rhs: The vector to subtract.
    /// - Returns: The difference of the two vectors.
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    
    
    
    
    /// Multiplies a vector by a scalar and returns the result.
    /// - Parameters:
    ///   - lhs: The vector.
    ///   - rhs: The scalar factor.
    /// - Returns: The scaled vector.
    public static func * (lhs: Vector, rhs: Scalar) -> Vector {
        return Vector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    
    
    
    
    /// Multiplies a scalar by a vector and returns the result.
    /// - Parameters:
    ///   - lhs: The scalar factor.
    ///   - rhs: The vector.
    /// - Returns: The scaled vector.
    public static func * (lhs: Scalar, rhs: Vector) -> Vector {
        return Vector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two vectors.
extension Vector: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated vector between two vectors.
    /// - Parameters:
    ///   - start: The vector at progress `0`.
    ///   - end: The vector at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated vector.
    public static func interpolate(from start: Vector, to end: Vector, progress: Scalar) -> Vector {
        return start + (end - start) * progress
    }
    
    
    
    
    
}

