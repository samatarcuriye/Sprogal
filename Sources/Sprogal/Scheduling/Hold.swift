import Foundation





// MARK: - Declaration

/// A playable that holds the current state for a given duration,
/// creating a pause between other animations on a timeline.
public struct Hold {
    
    
    
    
    
    /// The duration of the hold in seconds.
    public let duration: Scalar
    
    
    
    
    
    /// A no-op closure since no keyframes are added during a hold.
    public let apply: (_ startTime: Scalar) -> Void = { _ in }
    
    
    
    
    
    /// Creates a hold with the given duration.
    ///
    /// The duration must be zero or positive.
    /// A precondition failure occurs if the duration is negative.
    /// - Parameter duration: The hold duration in seconds.
    public init(duration: Scalar) {
        precondition(duration >= 0, "Hold duration must not be negative.")
        self.duration = duration
    }
    
    
    
    
    
}





// MARK: - Playable

/// Confirms that `Hold` can be scheduled on a timeline.
extension Hold: Playable {}

