




public struct Keyframe<Value: Interpolatable> {
    
    
    
    
    
    public let frame: Integer
    
    
    
    
    
    public let value: Value
    
    
    
    
    
    public let easing: Easing
    
    
    
    
    
    public init(frame: Integer, value: Value, easing: Easing = .linear) {
        self.frame = frame
        self.value = value
        self.easing = easing
    }
    
    
    
    
    
}
