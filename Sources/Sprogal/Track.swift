




public struct Track<Value: Interpolatable>: Keyframable {
    
    
    
    
    
    private var value: Value
    
    
    
    
    private var keyframeSequence: KeyframeSequence<Value> = KeyframeSequence()
    
    
    
    
    
    public var isKeyframingEnabled: Bool {
        return !self.keyframeSequence.isEmpty
    }
    
    
    
    

    public init(_ value: Value) {
        self.value = value
    }
    
    
    
    
    
    
    public mutating func enableKeyframing(at frame: Int) {
        precondition(!self.isKeyframingEnabled, "Keyframing is already enabled.")
        precondition(frame >= 0, "Frame must not be negative.")
        self.keyframeSequence.insertOrReplaceKeyframe(Keyframe(frame: frame, value: self.value))
    }
    
    
    
    
    
    public mutating func disableKeyframing(at frame: Int) {
        precondition(self.isKeyframingEnabled, "Keyframing is not enabled.")
        self.value = self.getValue(at: frame)
        self.keyframeSequence.removeAll()
    }
    
    
    
    
    
    
    public func getValue(at frame: Int) -> Value {
        
        if let keyframe = self.keyframeSequence.getKeyframe(at: frame) {
            return keyframe.value
        }

        let previousKeyframe = self.keyframeSequence.getKeyframe(before: frame)
        let nextKeyframe = self.keyframeSequence.getKeyframe(after: frame)

        guard let previousKeyframe else {
            return nextKeyframe?.value ?? self.value
        }
        guard let nextKeyframe else {
            return previousKeyframe.value
        }

        let elapsedFrames = frame - previousKeyframe.frame
        let totalFrames = nextKeyframe.frame - previousKeyframe.frame
        let linearProgress = Double(elapsedFrames) / Double(totalFrames)
        let easedProgress = previousKeyframe.easing.apply(linearProgress)
        return previousKeyframe.value.interpolated(to: nextKeyframe.value, fraction: easedProgress)
    }

    
    
    
    
    public mutating func setValue(_ newValue: Value, at frame: Int) {
        
        precondition(frame >= 0, "Frame must not be negative.")
        
        guard self.isKeyframingEnabled else {
            self.value = newValue
            return
        }
        
        let easing = self.keyframeSequence.getKeyframe(at: frame)?.easing
            ?? self.keyframeSequence.getKeyframe(before: frame)?.easing
            ?? .linear
        self.keyframeSequence.insertOrReplaceKeyframe(Keyframe(frame: frame, value: newValue, easing: easing))
    }
    
    
    
    
    
    
    @discardableResult
    public mutating func setEasing(_ easing: Easing, at frame: Int) -> Bool {
        guard var keyframe = self.keyframeSequence.getKeyframe(at: frame) else { return false }
        keyframe.easing = easing
        self.keyframeSequence.insertOrReplaceKeyframe(keyframe)
        return true
    }
    
    
    
    
    
    public func getKeyframe(at frame: Int) -> Keyframe<Value>? {
        return self.keyframeSequence.getKeyframe(at: frame)
    }
    
    
    
    
    public func getKeyframe(before frame: Int) -> Keyframe<Value>? {
        return self.keyframeSequence.getKeyframe(before: frame)
    }
    
    
    
    
    public func getKeyframe(after frame: Int) -> Keyframe<Value>? {
        return self.keyframeSequence.getKeyframe(after: frame)
    }
    
    
    
    
    
    public mutating func insertOrReplaceKeyframe(_ keyframe: Keyframe<Value>) {
        precondition(self.isKeyframingEnabled, "Keyframing is not enabled.")
        precondition(keyframe.frame >= 0, "Frame must not be negative.")
        self.keyframeSequence.insertOrReplaceKeyframe(keyframe)
    }
    
    
    
    
    @discardableResult
    public mutating func removeKeyframe(at frame: Int) -> Keyframe<Value>? {
        guard let removed = self.keyframeSequence.removeKeyframe(at: frame) else { return nil }
        if self.keyframeSequence.isEmpty {
            self.value = removed.value
        }
        return removed
    }

    
    
    
    
}
