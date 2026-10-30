/// A circle centered on the node's local origin, so with the default
/// anchor the circle's center sits on `position`.
open class Circle: ShapeNode {




    public let radius: Track<Scalar>




    public init(
        name: String? = nil,
        radius: Scalar,
        fillColor: Color,
        strokeColor: Color = .black,
        strokeWidth: Scalar = 0
    ) {
        self.radius = Track(radius)
        super.init(
            name: name,
            path: BezierPath(),
            fillColor: fillColor,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth
        )
    }




    open override var tracks: [Keyframable] {
        return super.tracks + [self.radius]
    }




    open override func makePath(at frame: Integer) -> BezierPath {
        return Circle.circle(radius: self.radius.getValue(at: frame))
    }




    /// A circle made of four cubic curves, one per quarter, starting at (r, 0)
    /// and running counterclockwise.
    public static func circle(radius r: Scalar) -> BezierPath {
        // Control point distance for a quarter circle approximated by one cubic.
        let k = r * 0.5522847498

        var path = BezierPath()
        path.move(to: Point2D(x: r, y: 0))
        path.addCurve(to: Point2D(x: 0, y: r), controlPoint1: Point2D(x: r, y: k), controlPoint2: Point2D(x: k, y: r))
        path.addCurve(to: Point2D(x: -r, y: 0), controlPoint1: Point2D(x: -k, y: r), controlPoint2: Point2D(x: -r, y: k))
        path.addCurve(to: Point2D(x: 0, y: -r), controlPoint1: Point2D(x: -r, y: -k), controlPoint2: Point2D(x: -k, y: -r))
        path.addCurve(to: Point2D(x: r, y: 0), controlPoint1: Point2D(x: k, y: -r), controlPoint2: Point2D(x: r, y: -k))
        path.close()
        return path
    }
}

