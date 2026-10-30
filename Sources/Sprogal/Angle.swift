




public struct Angle {
    
    
    
    
    
    public let radians: Scalar
    
    
    
    
    
    public init(radians: Scalar) {
        self.radians = radians
    }
    
    
    
    
    
}






extension Angle: Interpolatable {
    
    
    
    
    public func interpolated(to other: Angle, fraction: Scalar) -> Angle {
        return self + (other - self) * fraction
    }
}






extension Angle {
    
    
    
    
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians + rhs.radians)
    }
    
    
    
    
    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians - rhs.radians)
    }
    
    
    
    
    public static func * (lhs: Angle, rhs: Scalar) -> Angle {
        return Angle(radians: lhs.radians * rhs)
    }
    
    
    
    
    public static func * (lhs: Scalar, rhs: Angle) -> Angle {
        return rhs * lhs
    }
}
