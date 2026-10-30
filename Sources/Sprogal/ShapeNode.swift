/// Draws a closed path with a fill and a stroke. The fill is drawn first,
/// so the stroke sits on top of it.
///
/// The stroke width defaults to 0, so a shape is fill-only unless you
/// give it a stroke. Open subpaths are filled as if they were closed.
open class ShapeNode: PathNode {




    public var fillColor: Color




    public init(
        name: String? = nil,
        path: BezierPath,
        fillColor: Color,
        strokeColor: Color = .black,
        strokeWidth: Scalar = 0
    ) {
        self.fillColor = fillColor
        super.init(name: name, path: path, strokeColor: strokeColor, strokeWidth: strokeWidth)
    }




    open override func draw(frame: Integer, in canvas: Canvas) {
        canvas.fill(self.makePath(at: frame), color: self.fillColor)
        super.draw(frame: frame, in: canvas)
    }
}

