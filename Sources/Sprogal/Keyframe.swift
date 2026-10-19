




public struct Keyframe<Value> {
    
    
    
    
    
    public let frame: Integer
    
    
    
    
    
    public var value: Value
    
    
    
    
    
    public var easing: Easing
    
    
    
    
    
    public init(frame: Integer, value: Value, easing: Easing = .linear) {
        self.frame = frame
        self.value = value
        self.easing = easing
    }
    
    
    
    
    
}
