




public struct Rect2D {
    
    
    
    public let origin: Point2D
    
    
    
    
    public let size: Size2D
    
    
    
    
    public init(origin: Point2D, size: Size2D) {
        self.origin = origin
        self.size = size
    }
}






// MARK: Edges
extension Rect2D {





    /// The left edge's x.
    public var minX: Scalar { return self.origin.x }

    /// The right edge's x.
    public var maxX: Scalar { return self.origin.x + self.size.width }

    /// The horizontal middle's x.
    public var midX: Scalar { return self.origin.x + self.size.width / 2 }





    /// The bottom edge's y. The scene's y axis points up.
    public var minY: Scalar { return self.origin.y }

    /// The top edge's y. The scene's y axis points up.
    public var maxY: Scalar { return self.origin.y + self.size.height }

    /// The vertical middle's y.
    public var midY: Scalar { return self.origin.y + self.size.height / 2 }





}





// MARK: Points
extension Rect2D {
    
    
    
    
    
    public var center: Point2D { return Point2D(x: self.midX, y: self.midY) }
    
    
    
    
    
    /// The middle of the left edge.
    public var left: Point2D { return Point2D(x: self.minX, y: self.midY) }
    
    /// The middle of the right edge.
    public var right: Point2D { return Point2D(x: self.maxX, y: self.midY) }
    
    /// The middle of the top edge.
    public var top: Point2D { return Point2D(x: self.midX, y: self.maxY) }
    
    /// The middle of the bottom edge.
    public var bottom: Point2D { return Point2D(x: self.midX, y: self.minY) }
    
    
    
    
    
    public var topLeft: Point2D { return Point2D(x: self.minX, y: self.maxY) }
    
    public var topRight: Point2D { return Point2D(x: self.maxX, y: self.maxY) }
    
    public var bottomLeft: Point2D { return Point2D(x: self.minX, y: self.minY) }
    
    public var bottomRight: Point2D { return Point2D(x: self.maxX, y: self.minY) }
    
    
    
    
    
}

