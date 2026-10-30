




/// One connected outline: a chain of cubic curves where each curve's
/// `endPoint` is the next curve's `startPoint`.
public struct BezierSubpath {

    /// The curves that make up the outline, in drawing order.
    public internal(set) var curves: [BezierCurve]

    /// Whether the outline loops back to where it began.
    public internal(set) var isClosed: Bool

    init(curves: [BezierCurve] = [], isClosed: Bool = false) {
        self.curves = curves
        self.isClosed = isClosed
    }
}
