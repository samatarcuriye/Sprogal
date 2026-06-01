import Foundation





// MARK: Declaration

/// A type that can be smoothly interpolated between two values.
///
/// Conforming types provide a way to compute intermediate values
/// between a start and end value, enabling keyframe animation in Sprogal.
public protocol Interpolatable {
    
    
    
    
    
    /// Computes an intermediate value between two values.
    /// - Parameters:
    ///   - start: The value at progress `0`.
    ///   - end: The value at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated value.
    static func interpolate(from start: Self, to end: Self, progress: Scalar) -> Self
    
    
    
    
    
}
