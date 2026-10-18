




struct KeyframeSequence<Value: Interpolatable> {
    
    
    
    
    
    private(set) var keyframes: [Keyframe<Value>] = []
    
    
    
    
    
    var isEmpty: Bool { self.keyframes.isEmpty }
    
    
    
    
    
    init() {}
    
    
    
    
    
    private func getLowerBound(for frame: Int) -> Int {
        
        
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
    
    
    
    
    
    
    func getKeyframe(at frame: Int) -> Keyframe<Value>? {
        let index = self.getLowerBound(for: frame)
        guard index < self.keyframes.count, self.keyframes[index].frame == frame else { return nil }
        return self.keyframes[index]
    }
    
    
    
    
    
    func getKeyframe(before frame: Int) -> Keyframe<Value>? {
        let index = self.getLowerBound(for: frame)
        return index > 0 ? self.keyframes[index - 1] : nil
    }
    
    
    
    
    
    
    func getKeyframe(after frame: Int) -> Keyframe<Value>? {
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
    mutating func removeKeyframe(at frame: Int) -> Keyframe<Value>? {
        let index = self.getLowerBound(for: frame)
        guard index < self.keyframes.count, self.keyframes[index].frame == frame else { return nil }
        return self.keyframes.remove(at: index)
    }
    
    
    
    
    
    mutating func removeAll() {
        self.keyframes.removeAll()
    }
    
    
    
    
    
}
