




public typealias Scalar = Float





extension Scalar: Interpolatable {
    
    
    
    
    
    public func interpolated(to other: Float, fraction: Scalar) -> Float {
        return self + (other - self) * fraction
    }
    
    
    
    
    
}
