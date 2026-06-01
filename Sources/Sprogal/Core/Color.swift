import Foundation





// MARK: - Declaration

/// A color represented by red, green, blue, and alpha components,
/// each stored as a `Scalar` in the range `0` to `1`.
public struct Color {
    
    
    
    
    
    /// The red component.
    public let red: Scalar
    
    
    
    
    
    /// The green component.
    public let green: Scalar
    
    
    
    
    
    /// The blue component.
    public let blue: Scalar
    
    
    
    
    
    /// The alpha (opacity) component.
    public let alpha: Scalar
    
    
    
    
    
    /// Creates a color with the given components.
    ///
    /// Each component must be in the range `0` to `1`.
    /// A precondition failure occurs if any component falls outside that range.
    /// - Parameters:
    ///   - red: The red component, from `0` (none) to `1` (full).
    ///   - green: The green component, from `0` (none) to `1` (full).
    ///   - blue: The blue component, from `0` (none) to `1` (full).
    ///   - alpha: The alpha component, from `0` (transparent) to `1` (opaque). Defaults to `1`.
    public init(red: Scalar, green: Scalar, blue: Scalar, alpha: Scalar = 1) {
        precondition(red >= 0 && red <= 1, "Red component must be between 0 and 1.")
        precondition(green >= 0 && green <= 1, "Green component must be between 0 and 1.")
        precondition(blue >= 0 && blue <= 1, "Blue component must be between 0 and 1.")
        precondition(alpha >= 0 && alpha <= 1, "Alpha component must be between 0 and 1.")
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Linear interpolation between two colors, component by component.
extension Color: Interpolatable {
    
    
    
    
    
    /// Computes a linearly interpolated color between two colors.
    ///
    /// Each component is interpolated independently. The resulting components
    /// are guaranteed to remain in the range `0` to `1` when `progress`
    /// is in that range.
    /// - Parameters:
    ///   - start: The color at progress `0`.
    ///   - end: The color at progress `1`.
    ///   - progress: A scalar from `0` to `1` representing how far to interpolate.
    /// - Returns: The interpolated color.
    public static func interpolate(from start: Color, to end: Color, progress: Scalar) -> Color {
        return Color(
            red: Scalar.interpolate(from: start.red, to: end.red, progress: progress),
            green: Scalar.interpolate(from: start.green, to: end.green, progress: progress),
            blue: Scalar.interpolate(from: start.blue, to: end.blue, progress: progress),
            alpha: Scalar.interpolate(from: start.alpha, to: end.alpha, progress: progress)
        )
    }
    
    
    
    
    
}

