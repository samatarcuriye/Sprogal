import Foundation





// MARK: - Declaration

/// An easing curve that maps normalized time (0 to 1) to an output value,
/// controlling the rate of change during interpolation.
public enum Easing {
    
    
    
    
    
    /// Constant rate of change.
    case linear
    
    
    
    
    
    /// Holds the start value until the end.
    case hold
    
    
    
    
    
    /// Starts slow and accelerates (quadratic).
    case quadraticIn
    
    
    
    
    
    /// Starts fast and decelerates (quadratic).
    case quadraticOut
    
    
    
    
    
    /// Starts slow and accelerates through the first half, then decelerates
    /// through the second half (quadratic).
    case quadraticInOut
    
    
    
    
    
    /// Starts slow and accelerates (cubic).
    case cubicIn
    
    
    
    
    
    /// Starts fast and decelerates (cubic).
    case cubicOut
    
    
    
    
    
    /// Starts slow, accelerates through the middle, and decelerates at the end (cubic).
    case cubicInOut
    
    
    
    
    
    /// A custom easing function that takes normalized time and returns eased progress.
    case custom((Double) -> Double)
    
    
    
    
    
}





// MARK: - Application

/// Applies the easing curve to a normalized time value.
extension Easing {
    
    
    
    
    
    /// Maps a normalized time value through this easing curve.
    /// - Parameter normalizedTime: A scalar from `0` to `1` representing linear progress.
    /// - Returns: The eased progress value.
    public func apply(_ normalizedTime: Scalar) -> Scalar {
        switch self {
        case .linear:
            return normalizedTime
        case .hold:
            return 0
        case .quadraticIn:
            return normalizedTime * normalizedTime
        case .quadraticOut:
            let inverse: Scalar = 1 - normalizedTime
            return 1 - inverse * inverse
        case .quadraticInOut:
            if normalizedTime.value < 0.5 {
                return 2 * normalizedTime * normalizedTime
            } else {
                let shifted: Scalar = -2 * normalizedTime + 2
                return 1 - shifted * shifted * Scalar(0.5)
            }
        case .cubicIn:
            return normalizedTime * normalizedTime * normalizedTime
        case .cubicOut:
            let inverse: Scalar = 1 - normalizedTime
            return 1 - inverse * inverse * inverse
        case .cubicInOut:
            if normalizedTime.value < 0.5 {
                return 4 * normalizedTime * normalizedTime * normalizedTime
            } else {
                let shifted: Scalar = -2 * normalizedTime + 2
                return 1 - shifted * shifted * shifted * Scalar(0.5)
            }
        case .custom(let easingFunction):
            return Scalar(easingFunction(normalizedTime.value))
        }
    }
    
    
    
    
    
}

