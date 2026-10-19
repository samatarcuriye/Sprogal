




public typealias Scalar = Double





extension Scalar: Interpolatable {
    
    
    
    
    
    public func interpolated(to other: Scalar, fraction: Double) -> Scalar {
        return self + (other - self) * fraction
    }
    
    
    
    
    
}
