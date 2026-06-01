import Foundation





// MARK: - Declaration

/// A time-based sequence of keyframes that resolves to an interpolated value
/// at any point in time.
public struct Track<Value: Interpolatable> {
    
    
    
    
    
    // MARK: Keyframe
    
    /// A single keyframe within a track, holding a value and optionally
    /// a time and easing curve for animation.
    public struct Keyframe {
        
        
        
        
        
        /// The value at this keyframe.
        public let value: Value
        
        
        
        
        
        /// The time at which this keyframe occurs, or `nil` for a static keyframe.
        public let time: Scalar?
        
        
        
        
        
        /// The easing curve used to interpolate toward this keyframe, or `nil` for a static keyframe.
        public let easing: Easing?
        
        
        
        
        
        /// Creates a static keyframe with no time or easing.
        /// - Parameter value: The keyframe value.
        public init(_ value: Value) {
            self.value = value
            self.time = nil
            self.easing = nil
        }
        
        
        
        
        
        /// Creates an animated keyframe at a specific time with an easing curve.
        ///
        /// The time must be zero or positive.
        /// A precondition failure occurs if the time is negative.
        /// - Parameters:
        ///   - value: The keyframe value.
        ///   - time: The time at which this keyframe occurs.
        ///   - easing: The easing curve used to interpolate toward this keyframe.
        public init(_ value: Value, time: Scalar, easing: Easing) {
            precondition(time >= 0, "Keyframe time must not be negative.")
            self.value = value
            self.time = time
            self.easing = easing
        }
        
        
        
        
        
    }
    
    
    
    
    
    /// The keyframes in this track, sorted by time.
    public private(set) var keyframes: [Keyframe]
    
    
    
    
    
    /// The most recently evaluated value after calling `update(at:)`.
    public private(set) var current: Value
    
    
    
    
    
    /// Creates a track with a single static value.
    /// - Parameter value: The initial value.
    public init(_ value: Value) {
        self.keyframes = [Keyframe(value)]
        self.current = value
    }
    
    
    
    
    
    /// Creates a track from an array of keyframes.
    /// - Parameter keyframes: The keyframes to populate the track with.
    /// - Throws: `TrackError.emptyTrack` if the array is empty.
    public init(_ keyframes: [Keyframe]) throws {
        guard let firstKeyframe = keyframes.first else {
            throw TrackError.emptyTrack
        }
        self.keyframes = keyframes
        self.current = firstKeyframe.value
    }
    
    
    
    
    
}





// MARK: - Public Methods

/// Methods for evaluating and modifying the track.
extension Track {
    
    
    
    
    
    /// Evaluates the track at the given time and stores the result in `current`.
    /// - Parameter time: The time to evaluate at.
    public mutating func update(at time: Scalar) {
        self.current = self.value(at: time)
    }
    
    
    
    
    
    /// Computes the interpolated value at the given time without storing it.
    /// - Parameter time: The time to evaluate at.
    /// - Returns: The interpolated value.
    public func value(at time: Scalar) -> Value {
        let animatedKeyframes = self.animatedKeyframes()
        
        guard let firstKeyframe = animatedKeyframes.first else {
            return self.staticValue()
        }
        
        guard let lastKeyframe = animatedKeyframes.last else {
            return firstKeyframe.value
        }
        
        if self.isBefore(time: time, keyframe: firstKeyframe) {
            return firstKeyframe.value
        }
        
        if self.isAfter(time: time, keyframe: lastKeyframe) {
            return lastKeyframe.value
        }
        
        return self.interpolate(at: time, between: animatedKeyframes)
    }
    
    
    
    
    
    /// Adds a keyframe to the track, maintaining time-sorted order.
    /// - Parameter keyframe: The keyframe to add.
    public mutating func addKeyframe(_ keyframe: Keyframe) {
        self.keyframes.append(keyframe)
        self.keyframes.sort { firstKeyframe, secondKeyframe in
            let firstTime = firstKeyframe.time?.value ?? -Double.infinity
            let secondTime = secondKeyframe.time?.value ?? -Double.infinity
            return firstTime < secondTime
        }
    }
    
    
    
    
    
}





// MARK: - Private Methods

/// Internal methods for keyframe evaluation and interpolation.
extension Track {
    
    
    
    
    
    /// Returns only the keyframes that have both a time and an easing curve.
    private func animatedKeyframes() -> [Keyframe] {
        return self.keyframes.filter { $0.time != nil && $0.easing != nil }
    }
    
    
    
    
    
    /// Returns the value of the first keyframe, or the current value if no keyframes exist.
    private func staticValue() -> Value {
        return self.keyframes.first?.value ?? self.current
    }
    
    
    
    
    
    /// Returns `true` if the given time is strictly before the keyframe's time.
    private func isBefore(time: Scalar, keyframe: Keyframe) -> Bool {
        guard let keyframeTime = keyframe.time else { return false }
        return time < keyframeTime
    }
    
    
    
    
    
    /// Returns `true` if the given time is strictly after the keyframe's time.
    private func isAfter(time: Scalar, keyframe: Keyframe) -> Bool {
        guard let keyframeTime = keyframe.time else { return false }
        return time > keyframeTime
    }
    
    
    
    
    
    /// Finds the keyframe pair surrounding the given time and interpolates between them.
    private func interpolate(at time: Scalar, between keyframes: [Keyframe]) -> Value {
        for index in 0..<keyframes.count - 1 {
            let previousKeyframe = keyframes[index]
            let nextKeyframe = keyframes[index + 1]
            
            guard let previousTime = previousKeyframe.time,
                  let nextTime = nextKeyframe.time,
                  let nextEasing = nextKeyframe.easing else {
                continue
            }
            
            let isWithinRange = time.value >= previousTime.value
                             && time.value <= nextTime.value
            guard isWithinRange else { continue }
            
            let normalizedTime = self.normalizeTime(time: time, rangeStart: previousTime, rangeEnd: nextTime)
            let easedProgress = nextEasing.apply(normalizedTime)
            
            return Value.interpolate(from: previousKeyframe.value, to: nextKeyframe.value, progress: easedProgress)
        }
        
        return self.current
    }
    
    
    
    
    
    /// Maps a time value into the `0...1` range between two boundary times.
    private func normalizeTime(time: Scalar, rangeStart: Scalar, rangeEnd: Scalar) -> Scalar {
        let timeSpan = rangeEnd.value - rangeStart.value
        guard timeSpan > 0 else { return 0 }
        return Scalar((time.value - rangeStart.value) / timeSpan)
    }
    
    
    
    
    
}





// MARK: - TrackError

/// Errors that can occur when creating a track.
extension Track {
    
    
    
    
    
    /// Errors specific to track creation and validation.
    public enum TrackError: Error {
        
        
        
        
        
        /// The track was initialized with an empty array of keyframes.
        case emptyTrack
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - LocalizedError

/// Provides human-readable descriptions for track errors.
extension Track.TrackError: LocalizedError {
    
    
    
    
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .emptyTrack:
            return "Empty track."
        }
    }
    
    
    
    
    
}

