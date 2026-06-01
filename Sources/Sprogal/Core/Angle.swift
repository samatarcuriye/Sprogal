import Foundation





// MARK: - Declaration

/// An angle measured in radians.
public struct Angle {
    
    
    
    
    
    /// The angle value in radians.
    public let radians: Scalar
    
    
    
    
    
    /// Creates an angle with the given radian value.
    /// - Parameter radians: The angle in radians. Defaults to `0`.
    public init(radians: Scalar = 0) {
        self.radians = radians
    }
    
    
    
    
    
    /// Creates an angle from a value in degrees.
    /// - Parameter degrees: The angle in degrees.
    public init(degrees: Scalar) {
        self.radians = degrees * Scalar.pi / 180
    }
    
    
    
    
    
}





// MARK: - Properties

/// Computed properties that expose the angle in different units.
extension Angle {
    
    
    
    
    
    /// The angle value in degrees.
    public var degrees: Scalar {
        return self.radians * 180 / Scalar.pi
    }
    
    
    
    
    
}





// MARK: - Arithmetic

/// Arithmetic operators for combining angles.
extension Angle {
    
    
    
    
    
    /// Adds two angles and returns the result.
    /// - Parameters:
    ///   - lhs: The first angle.
    ///   - rhs: The second angle.
    /// - Returns: The sum of the two angles.
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians + rhs.radians)
    }
    
    
    
    
    
    /// Subtracts the right angle from the left and returns the result.
    /// - Parameters:
    ///   - lhs: The angle to subtract from.
    ///   - rhs: The angle to subtract.
    /// - Returns: The difference of the two angles.
    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians - rhs.radians)
    }
    
    
    
    
    
    /// Multiplies an angle by a scalar and returns the result.
    /// - Parameters:
    ///   - lhs: The angle.
    ///   - rhs: The scalar factor.
    /// - Returns: The scaled angle.
    public static func * (lhs: Angle, rhs: Scalar) -> Angle {
        return Angle(radians: lhs.radians * rhs)
    }
    
    
    
    
    
}





// MARK: - Trigonometry

/// Trigonometric accessors for the angle.
extension Angle {
    
    
    
    
    
    /// The cosine of the angle.
    public var cos: Scalar {
        return Scalar(Foundation.cos(self.radians.value))
    }
    
    
    
    
    
    /// The sine of the angle.
    public var sin: Scalar {
        return Scalar(Foundation.sin(self.radians.value))
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two angles.
extension Angle: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated angle between two angles.
    /// - Parameters:
    ///   - start: The angle at progress `0`.
    ///   - end: The angle at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated angle.
    public static func interpolate(from start: Angle, to end: Angle, progress: Scalar) -> Angle {
        return start + (end - start) * progress
    }
    
    
    
    
    
}

