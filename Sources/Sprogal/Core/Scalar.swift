import Foundation





// MARK: - Declaration

/// A wrapper around `Double` that serves as the fundamental numeric type
/// for all calculations in Sprogal.
public struct Scalar {
    
    
    
    
    
    /// The underlying double-precision floating-point value.
    public let value: Double
    
    
    
    
    
    /// Creates a scalar from a double-precision floating-point value.
    /// - Parameter value: The numeric value to wrap.
    public init(_ value: Double) {
        self.value = value
    }
    
    
    
    
    
}





// MARK: - Sendable

/// Confirms that `Scalar` is safe to share across concurrency domains.
extension Scalar: Sendable {}





// MARK: - Constants

/// Mathematical constants and special values commonly used in Sprogal calculations.
extension Scalar {
    
    
    
    
    
    /// The mathematical constant π (pi).
    public static let pi = Scalar(Double.pi)
    
    
    
    
    
    /// Positive infinity.
    public static let infinity = Scalar(Double.infinity)
    
    
    
    
    
}





// MARK: - Properties

/// Computed properties that expose characteristics of the underlying value.
extension Scalar {
    
    
    
    
    
    /// The sign of this scalar's value.
    public var sign: FloatingPointSign {
        return self.value.sign
    }
    
    
    
    
    
}





// MARK: - Arithmetic

/// Arithmetic operators for combining and transforming scalar values.
extension Scalar {
    
    
    
    
    
    /// Returns the additive inverse of a scalar.
    /// - Parameter operand: The scalar to negate.
    /// - Returns: The negated scalar.
    public static prefix func - (operand: Scalar) -> Scalar {
        return Scalar(-operand.value)
    }
    
    
    
    
    
    /// Adds two scalars and returns the result.
    /// - Parameters:
    ///   - lhs: The first addend.
    ///   - rhs: The second addend.
    /// - Returns: The sum of the two scalars.
    public static func + (lhs: Scalar, rhs: Scalar) -> Scalar {
        return Scalar(lhs.value + rhs.value)
    }
    
    
    
    
    
    /// Subtracts the right scalar from the left and returns the result.
    /// - Parameters:
    ///   - lhs: The scalar to subtract from.
    ///   - rhs: The scalar to subtract.
    /// - Returns: The difference of the two scalars.
    public static func - (lhs: Scalar, rhs: Scalar) -> Scalar {
        return Scalar(lhs.value - rhs.value)
    }
    
    
    
    
    
    /// Multiplies two scalars and returns the result.
    /// - Parameters:
    ///   - lhs: The first factor.
    ///   - rhs: The second factor.
    /// - Returns: The product of the two scalars.
    public static func * (lhs: Scalar, rhs: Scalar) -> Scalar {
        return Scalar(lhs.value * rhs.value)
    }
    
    
    
    
    
    /// Divides the left scalar by the right and returns the result.
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The quotient of the two scalars.
    public static func / (lhs: Scalar, rhs: Scalar) -> Scalar {
        return Scalar(lhs.value / rhs.value)
    }
    
    
    
    
    
}





// MARK: - Comparable

/// Ordering and equality comparison between scalar values.
extension Scalar: Comparable {
    
    
    
    
    
    /// Returns a Boolean value indicating whether the first scalar is less than the second.
    /// - Parameters:
    ///   - lhs: The first scalar to compare.
    ///   - rhs: The second scalar to compare.
    /// - Returns: `true` if `lhs` is less than `rhs`.
    public static func < (lhs: Scalar, rhs: Scalar) -> Bool {
        return lhs.value < rhs.value
    }
    
    
    
    
    
    /// Returns a Boolean value indicating whether two scalars are equal.
    /// - Parameters:
    ///   - lhs: The first scalar to compare.
    ///   - rhs: The second scalar to compare.
    /// - Returns: `true` if both scalars have the same value.
    public static func == (lhs: Scalar, rhs: Scalar) -> Bool {
        return lhs.value == rhs.value
    }
    
    
    
    
    
}





// MARK: - Clamping

/// Value clamping for constraining a scalar to a given range.
extension Scalar {
    
    
    
    
    
    /// Returns this scalar clamped to the given closed range.
    /// - Parameter range: The closed range to clamp to.
    /// - Returns: The clamped scalar value.
    public func clamped(to range: ClosedRange<Scalar>) -> Scalar {
        return max(range.lowerBound, min(range.upperBound, self))
    }
    
    
    
    
    
}





// MARK: - Literal Expressibility

/// Allows `Scalar` to be initialized from integer and floating-point literals,
/// enabling natural syntax such as `let s: Scalar = 0` or `let s: Scalar = 3.14`.
extension Scalar: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    
    
    
    
    /// Creates a scalar from an integer literal.
    /// - Parameter value: The integer value, which is converted to `Double`.
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
    
    
    
    
    
    /// Creates a scalar from a floating-point literal.
    /// - Parameter value: The double-precision floating-point value.
    public init(floatLiteral value: Double) {
        self.value = value
    }
    
    
    
    
    
}





// MARK: - CustomStringConvertible

/// Provides a human-readable text representation of a scalar.
extension Scalar: CustomStringConvertible {
    
    
    
    
    
    /// A textual representation of this scalar's value.
    public var description: String {
        return "\(value)"
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two scalar values.
extension Scalar: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated value between two scalars.
    /// - Parameters:
    ///   - start: The value at progress `0`.
    ///   - end: The value at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated scalar value.
    public static func interpolate(from start: Scalar, to end: Scalar, progress: Scalar) -> Scalar {
        return start + (end - start) * progress
    }
    
    
    
    
    
}





// MARK: - Free Functions

/// Returns the absolute value of a scalar.
/// - Parameter scalar: The scalar value.
/// - Returns: The absolute value.
public func abs(_ scalar: Scalar) -> Scalar {
    return Scalar(Swift.abs(scalar.value))
}





/// Returns the square root of a scalar.
/// - Parameter scalar: The scalar value.
/// - Returns: The square root.
public func sqrt(_ scalar: Scalar) -> Scalar {
    return Scalar(Foundation.sqrt(scalar.value))
}





/// Returns the smaller of two scalars.
/// - Parameters:
///   - lhs: The first scalar.
///   - rhs: The second scalar.
/// - Returns: The smaller value.
public func min(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
    return lhs.value <= rhs.value ? lhs : rhs
}





/// Returns the larger of two scalars.
/// - Parameters:
///   - lhs: The first scalar.
///   - rhs: The second scalar.
/// - Returns: The larger value.
public func max(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
    return lhs.value >= rhs.value ? lhs : rhs
}

