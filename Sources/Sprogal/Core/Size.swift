import Foundation





// MARK: - Declaration

/// A two-dimensional size representing width and height.
public struct Size {
    
    
    
    
    
    /// The horizontal extent.
    public let width: Scalar
    
    
    
    
    
    /// The vertical extent.
    public let height: Scalar
    
    
    
    
    
    /// Creates a size with the given dimensions.
    ///
    /// Both dimensions must be zero or positive.
    /// A precondition failure occurs if either dimension is negative.
    /// - Parameters:
    ///   - width: The horizontal extent.
    ///   - height: The vertical extent.
    public init(width: Scalar, height: Scalar) {
        precondition(width >= 0, "Width must not be negative.")
        precondition(height >= 0, "Height must not be negative.")
        self.width = width
        self.height = height
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two sizes.
extension Size: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated size between two sizes.
    /// - Parameters:
    ///   - start: The size at progress `0`.
    ///   - end: The size at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated size.
    public static func interpolate(from start: Size, to end: Size, progress: Scalar) -> Size {
        return Size(
            width: start.width + (end.width - start.width) * progress,
            height: start.height + (end.height - start.height) * progress
        )
    }
    
    
    
    
    
}

