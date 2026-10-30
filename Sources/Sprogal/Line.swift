





/// A straight line between two animatable points, stroked like any PathNode.
open class Line: PathNode {




    public let start: Track<Point2D>




    public let end: Track<Point2D>




    public init(
        name: String? = nil,
        start: Point2D,
        end: Point2D,
        strokeColor: Color = .black,
        strokeWidth: Scalar = 1
    ) {
        self.start = Track(start)
        self.end = Track(end)
        super.init(name: name, path: BezierPath(), strokeColor: strokeColor, strokeWidth: strokeWidth)
    }




    open override var tracks: [Keyframable] {
        return super.tracks + [self.start, self.end]
    }




    open override func makePath(at frame: Integer) -> BezierPath {
        var path = BezierPath()
        path.move(to: self.start.getValue(at: frame))
        path.addLine(to: self.end.getValue(at: frame))
        return path
    }
}

