




public struct Scale2D {
    
    
    
    
    public let scaleX: Scalar
    
    
    
    
    public let scaleY: Scalar
    
    
    
    
    public init(scaleX: Scalar, scaleY: Scalar) {
        self.scaleX = scaleX
        self.scaleY = scaleY
    }
}






extension Scale2D: Interpolatable {
    
    
    
    
    public func interpolated(to other: Scale2D, fraction: Scalar) -> Scale2D {
        return Scale2D(
            scaleX: self.scaleX.interpolated(to: other.scaleX, fraction: fraction),
            scaleY: self.scaleY.interpolated(to: other.scaleY, fraction: fraction)
        )
    }
    
}
