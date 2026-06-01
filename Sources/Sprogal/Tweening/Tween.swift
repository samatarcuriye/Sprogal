import Foundation





// MARK: - Declaration

/// A playable that transitions a node's property from its current
/// value to a destination value over a fixed duration.
public struct Tween {
    
    
    
    
    
    /// The duration of the tween in seconds.
    public let duration: Scalar
    
    
    
    
    
    /// The identity of the node this tween targets.
    public let identity: ObjectIdentifier?
    
    
    
    
    
    /// The name of the property this tween animates
    /// (e.g. `"position"`, `"opacity"`, `"scale"`).
    public let property: String?
    
    
    
    
    
    /// A closure that receives a start time and adds keyframes to the target node's tracks.
    public let apply: (_ startTime: Scalar) -> Void
    
    
    
    
    
    /// Creates a tween with the given duration, target, property, and apply closure.
    ///
    /// The duration must be zero or positive.
    /// A precondition failure occurs if the duration is negative.
    /// - Parameters:
    ///   - duration: The duration of the tween in seconds.
    ///   - node: The node this tween targets. Defaults to `nil`.
    ///   - property: The property name this tween animates. Defaults to `nil`.
    ///   - apply: A closure that receives a start time and adds keyframes.
    public init(
        duration: Scalar,
        node: Node? = nil,
        property: String? = nil,
        apply: @escaping (_ startTime: Scalar) -> Void
    ) {
        precondition(duration >= 0, "Tween duration must not be negative.")
        self.duration = duration
        self.identity = node.map { ObjectIdentifier($0) }
        self.property = property
        self.apply = apply
    }
    
    
    
    
    
}





// MARK: - Playable

/// Confirms that `Tween` can be scheduled on a timeline.
extension Tween: Playable {}

