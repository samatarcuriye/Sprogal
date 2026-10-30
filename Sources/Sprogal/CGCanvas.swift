import CoreGraphics





public final class CGCanvas: Canvas {
    let context: CGContext




    init(context: CGContext) {
        self.context = context
    }

    public func save() {
        context.saveGState()
    }



    public func restore() {
        context.restoreGState()
    }



    public func translate(by offset: Vector2D) {
        context.translateBy(x: CGFloat(offset.dx), y: CGFloat(offset.dy))
    }



    public func concatenate(with transform: Transform2D) {
        context.concatenate(CGAffineTransform(
            a: CGFloat(transform.a),
            b: CGFloat(transform.b),
            c: CGFloat(transform.c),
            d: CGFloat(transform.d),
            tx: CGFloat(transform.tx),
            ty: CGFloat(transform.ty)
        ))
    }



    /// Fills using the nonzero winding rule. Open subpaths are filled as if closed.
    public func fill(_ path: BezierPath, color: Color) {
        context.setFillColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        context.addPath(self.makeCGPath(path))
        context.fillPath()
    }



    public func stroke(_ path: BezierPath, color: Color, width: Scalar) {
        context.setStrokeColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        context.setLineWidth(CGFloat(width))
        context.addPath(self.makeCGPath(path))
        context.strokePath()
    }



    private func makeCGPath(_ path: BezierPath) -> CGPath {
        let cgPath = CGMutablePath()

        for subpath in path.subpaths {
            guard let first = subpath.curves.first else { continue }

            cgPath.move(to: self.cgPoint(first.startPoint))
            for curve in subpath.curves {
                cgPath.addCurve(
                    to: self.cgPoint(curve.endPoint),
                    control1: self.cgPoint(curve.controlPoint1),
                    control2: self.cgPoint(curve.controlPoint2)
                )
            }
            if subpath.isClosed {
                cgPath.closeSubpath()
            }
        }

        return cgPath
    }



    private func cgPoint(_ point: Point2D) -> CGPoint {
        return CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
    }
}

