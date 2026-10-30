




public protocol Canvas {
    
    
    
    
    
    func save()
    func restore()
    func translate(by offset: Vector2D)
    func concatenate(with transform: Transform2D)
    func fill(_ path: BezierPath, color: Color)
    func stroke(_ path: BezierPath, color: Color, width: Scalar)
}
