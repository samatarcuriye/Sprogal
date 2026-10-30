




// MARK: Track
public final class Track<Value: Interpolatable> {
    
    
    
    
    
    private var expression: ((Integer) -> Value?)? = nil
    
    
    
    
    
    private var modifier: ((Integer, Value) -> Value?)? = nil
    
    private var state: State
    
    
    
    
    
    
    public var isKeyframed: Bool {
        switch self.state {
        case .keyframeSequence: return true
        case .value: return false
        }
    }
    
    
    
    
    
    public var keyframes: [Keyframe<Value>] {
        switch self.state {
        case .keyframeSequence(let keyframeSequence): return keyframeSequence.keyframes
        case .value: return []
        }
    }
    
    
    
    
    
    
    
    public init(_ value: Value) {
        self.state = .value(value)
    }
    
    
    
    
    
    public func setValue(_ value: Value) {
        self.state = .value(value)
    }
    
    
    
    
    
    public func setKeyframe(_ keyframe: Keyframe<Value>) {
        switch self.state {
        case .value:
            self.state = .keyframeSequence(KeyframeSequence(keyframe))
        case .keyframeSequence(var keyframeSequence):
            keyframeSequence.insertOrReplaceKeyframe(keyframe)
            self.state = .keyframeSequence(keyframeSequence)
        }
    }
    
    
    
    
    public func removeKeyframe(at frame: Integer) {
        guard case .keyframeSequence(var keyframeSequence) = self.state,
              let keyframe = keyframeSequence.getKeyframe(at: frame) else { return }

        if keyframeSequence.count == 1 {
            self.state = .value(keyframe.value)
        } else {
            keyframeSequence.removeKeyframe(at: frame)
            self.state = .keyframeSequence(keyframeSequence)
        }
    }
    
    
    
    
    
    public func setExpression(_ expression: @escaping (Integer) -> Value?) {
        self.expression = expression
    }
    
    
    
    
    
    public func removeExpression() {
        self.expression = nil
    }
    
    
    
    
    
    public func setModifier(_ modifier: @escaping (Integer, Value) -> Value?) {
        self.modifier = modifier
    }

    
    
    
    
    public func removeModifier() {
        self.modifier = nil
    }
    
    
    
    
    
    public func getValue(at frame: Integer) -> Value {
        let stateValue: Value
        switch self.state {
        case .value(let value):
            stateValue = value

        case .keyframeSequence(let keyframeSequence):
            stateValue = keyframeSequence.getValue(at: frame)
        }
            
        let value = self.expression?(frame) ?? stateValue
        return self.modifier?(frame, value) ?? value
    }
    
    
    
    
    
}





// MARK: State
extension Track {
    
    
    
    
    
    private enum State {
        
        
        
        
        
        case value(Value)
        
        
        
        
        
        case keyframeSequence(KeyframeSequence)
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: KeyframeSequence
extension Track {
    
    
    
    
    
    private struct KeyframeSequence {
        
        
        
        
        
        private(set) var keyframes: [Keyframe<Value>]
        
        
        
        
        
        var firstKeyframe: Keyframe<Value> { return self.keyframes[0] }
        
        
        
        
        
        var lastKeyframe: Keyframe<Value> { return self.keyframes[self.count - 1] }
        
        
        
        
        
        var count: Int { return self.keyframes.count }
        
        
        
        
        
        init(_ keyframe: Keyframe<Value>) {
            self.keyframes = [keyframe]
        }
        
        
        
        
        
        func getLowerBound(for frame: Integer) -> Int {
                
                
            var low = 0
            var high = self.keyframes.count
                
            while low < high {
                let middle = low + (high - low) / 2
                if self.keyframes[middle].frame < frame {
                    low = middle + 1
                } else {
                    high = middle
                }
            }
                
                
            return low
        }
        
        
        
        
        
        func getValue(at frame: Integer) -> Value {
            let index = self.getLowerBound(for: frame)

            
            if index < self.count, self.keyframes[index].frame == frame {
                return self.keyframes[index].value
            }

            
            guard index > 0 else { return self.firstKeyframe.value }

            
            guard index < self.count else { return self.lastKeyframe.value }

            
            let before = self.keyframes[index - 1]
            let after = self.keyframes[index]
            let fraction = Scalar(frame - before.frame) / Scalar(after.frame - before.frame)
            return before.value.interpolated(to: after.value, fraction: before.easing.apply(to: fraction))
        }
        
        
        
        
        
        func getKeyframe(at frame: Integer) -> Keyframe<Value>? {
            let index = self.getLowerBound(for: frame)
            guard index < self.keyframes.count, self.keyframes[index].frame == frame else { return nil }
            return self.keyframes[index]
        }
        
        
        
        
        
        func getKeyframe(before frame: Integer) -> Keyframe<Value>? {
            let index = self.getLowerBound(for: frame)
            return index > 0 ? self.keyframes[index - 1] : nil
        }
        
        
        
        
        
        func getKeyframe(after frame: Integer) -> Keyframe<Value>? {
            var index = self.getLowerBound(for: frame)
            if index < self.keyframes.count, self.keyframes[index].frame == frame {
                index += 1
            }
            return index < self.keyframes.count ? self.keyframes[index] : nil
        }
        
        
        
        
        
        mutating func insertOrReplaceKeyframe(_ keyframe: Keyframe<Value>) {
            let index = self.getLowerBound(for: keyframe.frame)
            if index < self.keyframes.count, self.keyframes[index].frame == keyframe.frame {
                self.keyframes[index] = keyframe
            } else {
                self.keyframes.insert(keyframe, at: index)
            }
        }
        
        
        
        
        
        @discardableResult
        mutating func removeKeyframe(at frame: Integer) -> Keyframe<Value>? {
            precondition(self.keyframes.count > 1, "A KeyframeSequence must contain at least one keyframe")
            let index = self.getLowerBound(for: frame)
            guard index < self.keyframes.count, self.keyframes[index].frame == frame else { return nil }
            return self.keyframes.remove(at: index)
        }
        
        
        
     
        
    }
    
    
    
    
    
}






extension Track: Keyframable {




    public var lastFrame: Integer? {
        return self.keyframes.last?.frame
    }
}
