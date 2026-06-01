import Foundation





// MARK: Declaration

/// A type that can be scheduled on a timeline with a duration
/// and an apply closure that sets up keyframes at a given start time.
public protocol Playable {
    
    
    
    
    
    /// The duration of this playable in seconds.
    var duration: Scalar { get }
    
    
    
    
    
    /// A closure that receives a start time and sets up keyframes on the target node's tracks.
    var apply: (_ startTime: Scalar) -> Void { get }
    
    
    
    
    
}


