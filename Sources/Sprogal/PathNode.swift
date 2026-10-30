




/// Draws the outline of a path: a stroke and no fill.
///
/// Use it for open paths such as lines and curves. The path is in the
/// node's local space.
open class PathNode: Node {




    public var path: BezierPath




    public var strokeColor: Color




    /// The stroke width in local units. A width of 0 or less draws no stroke.
    public let strokeWidth: Track<Scalar>




    public init(name: String? = nil, path: BezierPath, strokeColor: Color = .black, strokeWidth: Scalar = 1) {
        self.path = path
        self.strokeColor = strokeColor
        self.strokeWidth = Track(strokeWidth)
        super.init(name: name)
    }




    open override var tracks: [Keyframable] {
        return super.tracks + [self.strokeWidth]
    }


    
    
    
    
    /// The box around every point of the path at `frame`: start, end and control
    /// points. Exact for straight edges; for curves it can be slightly larger than
    /// the outline, but always contains it. An empty path gives an empty box at
    /// the origin.
    open override func getContentBounds(at frame: Integer) -> Rect2D {
        let points = self.makePath(at: frame).subpaths.flatMap { subpath in
            subpath.curves.flatMap { curve in
                [curve.startPoint, curve.controlPoint1, curve.controlPoint2, curve.endPoint]
            }
        }
        guard let firstPoint = points.first else { return super.getContentBounds(at: frame) }
        
        var minX = firstPoint.x
        var maxX = firstPoint.x
        var minY = firstPoint.y
        var maxY = firstPoint.y
        
        for point in points.dropFirst() {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }
        
        return Rect2D(
            origin: Point2D(x: minX, y: minY),
            size: Size2D(width: maxX - minX, height: maxY - minY)
        )
    }


    /// The path to draw at `frame`. Returns `path` by default; subclasses that
    /// generate their path from animated values override this.
    open func makePath(at frame: Integer) -> BezierPath {
        return self.path
    }




    open override func draw(frame: Integer, in canvas: Canvas) {
        let width = self.strokeWidth.getValue(at: frame)
        guard width > 0 else { return }
        canvas.stroke(self.makePath(at: frame), color: self.strokeColor, width: width)
    }
}
