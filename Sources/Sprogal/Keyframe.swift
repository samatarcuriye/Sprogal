




public struct Keyframe<Value> {
    
    
    
    
    
    public let frame: Int
    
    
    
    
    
    public var value: Value
    
    
    
    
    
    public var easing: Easing = Easing.linear
    
    
    
    
    
    public init(frame: Int, value: Value, easing: Easing = Easing.linear) {
        self.frame = frame
        self.value = value
        self.easing = easing
    }
    
    
    
    
    
}
