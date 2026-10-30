




/// A backend-independent 2D shape made of cubic Bézier curves.
///
/// Build a path like drawing with a pen: `move(to:)` to start an outline,
/// `addLine(to:)` and `addCurve(to:controlPoint1:controlPoint2:)` to draw,
/// and `close()` to finish it. Every segment is stored as a cubic curve.
///
/// All points are locations in the space the path is drawn in
/// (typically the local space of the node that owns it).
public struct BezierPath {

    /// The separate outlines that make up this shape.
    public private(set) var subpaths: [BezierSubpath] = []

    /// Where the pen is now.
    private var currentPoint: Point2D?

    /// Where the current outline began; `close()` draws back to it.
    private var subpathStartPoint: Point2D?

    public init() {}
}

// MARK: - Building

extension BezierPath {

    /// Lifts the pen and puts it down at `point`, starting a new outline.
    public mutating func move(to point: Point2D) {
        if let last = subpaths.last, last.curves.isEmpty {
            // The previous move drew nothing, so reuse its empty subpath.
            subpaths[subpaths.count - 1] = BezierSubpath()
        } else {
            subpaths.append(BezierSubpath())
        }
        currentPoint = point
        subpathStartPoint = point
    }

    /// Draws a straight line from the pen's position to `point`.
    public mutating func addLine(to point: Point2D) {
        append(.line(from: requireCurrentPoint(), to: point))
    }

    /// Draws a cubic curve from the pen's position to `point`.
    public mutating func addCurve(to point: Point2D, controlPoint1: Point2D, controlPoint2: Point2D) {
        append(BezierCurve(
            startPoint: requireCurrentPoint(),
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2,
            endPoint: point
        ))
    }

    /// Finishes the current outline.
    ///
    /// If the pen isn't already back at the outline's start, a straight
    /// line is drawn there first.
    public mutating func close() {
        guard let startPoint = subpathStartPoint, !subpaths.isEmpty else { return }

        if let current = currentPoint, current.x != startPoint.x || current.y != startPoint.y {
            addLine(to: startPoint)
        }
        subpaths[subpaths.count - 1].isClosed = true
        currentPoint = startPoint
    }
}

// MARK: - Private helpers

extension BezierPath {

    private mutating func append(_ curve: BezierCurve) {
        // Drawing after close() starts a new outline at the pen's position.
        if subpaths.isEmpty || subpaths[subpaths.count - 1].isClosed {
            subpaths.append(BezierSubpath())
            subpathStartPoint = curve.startPoint
        }
        subpaths[subpaths.count - 1].curves.append(curve)
        currentPoint = curve.endPoint
    }

    private func requireCurrentPoint() -> Point2D {
        guard let point = currentPoint else {
            preconditionFailure("BezierPath: call move(to:) before drawing.")
        }
        return point
    }
}

