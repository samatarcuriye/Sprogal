import Foundation





// MARK: - Declaration

/// A sequencer that schedules playable items one after another,
/// or in parallel, and prepares them for playback by assigning
/// start times.
public class Timeline {
    
    
    
    
    
    /// The current cursor position, representing the end time
    /// of the last appended item.
    private var cursor: Scalar = 0
    
    
    
    
    
    /// The scheduled entries, each pairing a playable with its
    /// start time.
    private var entries: [(playable: Playable, startTime: Scalar)] = []
    
    
    
    
    
}





// MARK: - Properties

/// Computed properties that expose characteristics of the timeline.
extension Timeline {
    
    
    
    
    
    /// The total duration of all scheduled items.
    public var duration: Scalar {
        return self.cursor
    }
    
    
    
    
    
}





// MARK: - Appending

/// Methods for scheduling playable items onto the timeline.
extension Timeline {
    
    
    
    
    
    /// Appends a playable item to the timeline, starting at
    /// the current cursor position.
    ///
    /// The cursor advances by the item's duration, so the next
    /// appended item starts after this one ends.
    /// - Parameter playable: The item to append.
    public func append(_ playable: Playable) {
        self.entries.append((playable: playable, startTime: self.cursor))
        self.cursor = self.cursor + playable.duration
    }
    
    
    
    
    
    /// Appends multiple playable items in parallel, all starting
    /// at the current cursor position.
    ///
    /// The cursor advances by the duration of the longest item.
    /// - Parameter playables: The items to play simultaneously.
    public func append(_ playables: Playable...) {
        let parallelStartTime = self.cursor
        var longestDuration: Scalar = 0
        
        for playable in playables {
            self.entries.append((playable: playable, startTime: parallelStartTime))
            if playable.duration.value > longestDuration.value {
                longestDuration = playable.duration
            }
        }
        
        self.cursor = self.cursor + longestDuration
    }
    
    
    
    
    
    /// Appends all tweens from a builder in parallel, starting
    /// at the current cursor position.
    ///
    /// The cursor advances by the duration of the longest tween.
    /// - Parameter builder: The tween builder whose tweens to
    ///   append.
    public func append(_ builder: TweenBuilder) {
        let parallelStartTime = self.cursor
        var longestDuration: Scalar = 0
        
        for tween in builder.tweens {
            self.entries.append((playable: tween, startTime: parallelStartTime))
            if tween.duration.value > longestDuration.value {
                longestDuration = tween.duration
            }
        }
        
        self.cursor = self.cursor + longestDuration
    }
    
    
    
    
    
}





// MARK: - Playback

/// Methods for preparing the timeline for playback.
extension Timeline {
    
    
    
    
    
    /// Prepares all scheduled items for playback by calling
    /// each item's apply closure with its assigned start time.
    public func prepare() {
        for entry in self.entries {
            entry.playable.apply(entry.startTime)
        }
    }
    
    
    
    
    
}

