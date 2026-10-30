




/// A single cubic Bézier curve.
///
/// This is the only curve type in the library. Everything a path contains,
/// including straight lines, is stored as one of these.
///
/// All points are locations in the space the curve is drawn in.
public struct BezierCurve {

    /// Where the curve begins.
    public var startPoint: Point2D

    /// Shapes the curve as it leaves `startPoint`.
    public var controlPoint1: Point2D

    /// Shapes the curve as it arrives at `endPoint`.
    public var controlPoint2: Point2D

    /// Where the curve finishes.
    public var endPoint: Point2D

    public init(startPoint: Point2D, controlPoint1: Point2D, controlPoint2: Point2D, endPoint: Point2D) {
        self.startPoint = startPoint
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.endPoint = endPoint
    }
}

extension BezierCurve {

    /// A straight line expressed as a cubic, with control points 1/3 and 2/3
    /// of the way along the line.
    static func line(from startPoint: Point2D, to endPoint: Point2D) -> BezierCurve {
        BezierCurve(
            startPoint: startPoint,
            controlPoint1: startPoint.interpolated(to: endPoint, fraction: 1.0 / 3.0),
            controlPoint2: startPoint.interpolated(to: endPoint, fraction: 2.0 / 3.0),
            endPoint: endPoint
        )
    }
}

