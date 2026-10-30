





/// A square slides right while spinning and growing around its center.
//final class TransformScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        var path = BezierPath()
//        path.move(to: Point2D(x: 0, y: 0))
//        path.addLine(to: Point2D(x: 300, y: 0))
//        path.addLine(to: Point2D(x: 300, y: 300))
//        path.addLine(to: Point2D(x: 0, y: 300))
//        path.close()
//        
//        let square = ShapeNode(path: path, fillColor: .white)
//        
//        
//        
//        // Anchor: the square's center, so it spins and grows in place.
//        square.anchor.setValue(Point2D(x: 150, y: 150))
//        
//        // Position: slide from left to right.
//        square.position.setKeyframe(Keyframe(frame: 0, value: Point2D(x: -1000, y: 0)))
//        square.position.setKeyframe(Keyframe(frame: 120, value: Point2D(x: 1000, y: 0)))
//        
//        // Rotation: one full turn.
//        square.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0)))
//        square.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: 2 * .pi)))
//        
//        // Scale: grow to twice its size.
//        square.scale.setKeyframe(Keyframe(frame: 0, value: Scale2D(scaleX: 1, scaleY: 1)))
//        square.scale.setKeyframe(Keyframe(frame: 120, value: Scale2D(scaleX: 2, scaleY: 2)))
//        
//        
//        
//        self.addChild(square)
//    }
//}




/// Four squares turn one full circle, each around a different anchor point:
/// bottom-left corner, center, top-right corner, and a point below the square.
//final class AnchorScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let side: Scalar = 200
//        
//        let anchors = [
//            Point2D(x: 0, y: 0),                    // bottom-left corner
//            Point2D(x: side / 2, y: side / 2),      // center
//            Point2D(x: side, y: side),              // top-right corner
//            Point2D(x: side / 2, y: -150)           // outside, below the square
//        ]
//        
//        
//        
//        for (index, anchor) in anchors.enumerated() {
//            let position = Point2D(x: -1200 + Scalar(index) * 800, y: 0)
//            
//            
//            
//            // The square, drawn from its bottom-left corner.
//            var path = BezierPath()
//            path.move(to: Point2D(x: 0, y: 0))
//            path.addLine(to: Point2D(x: side, y: 0))
//            path.addLine(to: Point2D(x: side, y: side))
//            path.addLine(to: Point2D(x: 0, y: side))
//            path.close()
//            
//            let square = ShapeNode(path: path, fillColor: .white)
//            square.anchor.setValue(anchor)
//            square.position.setValue(position)
//            square.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            square.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: 2 * .pi)))
//            
//            
//            
//            // A red dot on the anchor, which is where the square's position is.
//            let marker = Circle(radius: 16, fillColor: Color(red: 1, green: 0.3, blue: 0.3))
//            marker.position.setValue(position)
//            
//            
//            
//            self.addChild(square)
//            self.addChild(marker)
//        }
//    }
//}








/// Four lines turn one full circle, each around a different anchor point:
/// the start, the middle, the end, and a point off the line.
//final class LineAnchorScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let length: Scalar = 300
//        
//        let anchors = [
//            Point2D(x: 0, y: 0),                    // start of the line
//            Point2D(x: length / 2, y: 0),           // middle
//            Point2D(x: length, y: 0),               // end of the line
//            Point2D(x: length / 2, y: -150)         // off the line, below its middle
//        ]
//        
//        
//        
//        for (index, anchor) in anchors.enumerated() {
//            let position = Point2D(x: -1200 + Scalar(index) * 800, y: 0)
//            
//            
//            
//            let line = Line(
//                start: Point2D(x: 0, y: 0),
//                end: Point2D(x: length, y: 0),
//                strokeColor: .white,
//                strokeWidth: 16
//            )
//            line.anchor.setValue(anchor)
//            line.position.setValue(position)
//            line.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            line.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: 2 * .pi)))
//            
//            
//            
//            // A red dot on the anchor, which is where the line's position is.
//            let marker = Circle(radius: 16, fillColor: Color(red: 1, green: 0.3, blue: 0.3))
//            marker.position.setValue(position)
//            
//            
//            
//            self.addChild(line)
//            self.addChild(marker)
//        }
//    }
//}




/// Three squares turn by different amounts. A red outline shows each square's
/// local bounds, and a red dot shows its local origin. Both live in the square's
/// own space, so they turn with it.
//final class BoundsScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let sides: [Scalar] = [200, 300, 400]
//        let turns: [Scalar] = [0.25, 0.5, 1]       // fraction of a full turn
//        
//        
//        
//        for index in 0..<3 {
//            let side = sides[index]
//            
//            
//            
//            // The square, drawn from its bottom-left corner, anchored at its center.
//            var path = BezierPath()
//            path.move(to: Point2D(x: 0, y: 0))
//            path.addLine(to: Point2D(x: side, y: 0))
//            path.addLine(to: Point2D(x: side, y: side))
//            path.addLine(to: Point2D(x: 0, y: side))
//            path.close()
//            
//            let square = ShapeNode(path: path, fillColor: .white)
//            square.anchor.setValue(Point2D(x: side / 2, y: side / 2))
//            square.position.setValue(Point2D(x: -1000 + Scalar(index) * 1000, y: 0))
//            square.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            square.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: turns[index] * 2 * .pi)))
//            
//            
//            
//            // Local bounds: a red outline, as a child so it shares the square's space.
//            if let bounds = square.getLocalBounds(at: 0) {
//                let outline = PathNode(
//                    path: self.makeRectanglePath(bounds),
//                    strokeColor: Color(red: 1, green: 0.3, blue: 0.3),
//                    strokeWidth: 8
//                )
//                square.addChild(outline)
//            }
//            
//            
//            
//            // Local origin: a red dot at (0, 0) in the square's space.
//            let origin = Circle(radius: 16, fillColor: Color(red: 1, green: 0.3, blue: 0.3))
//            square.addChild(origin)
//            
//            
//            
//            self.addChild(square)
//        }
//    }
//    
//    
//    
//    
//    private func makeRectanglePath(_ rect: Rect2D) -> BezierPath {
//        let minX = rect.origin.x
//        let minY = rect.origin.y
//        let maxX = minX + rect.size.width
//        let maxY = minY + rect.size.height
//        
//        var path = BezierPath()
//        path.move(to: Point2D(x: minX, y: minY))
//        path.addLine(to: Point2D(x: maxX, y: minY))
//        path.addLine(to: Point2D(x: maxX, y: maxY))
//        path.addLine(to: Point2D(x: minX, y: maxY))
//        path.close()
//        return path
//    }
//}






/// Three squares turn by different amounts. Each is drawn centered on its local
/// origin. A red outline shows its local bounds, and a red dot shows its local
/// origin, which is also its anchor. Both live in the square's own space, so they
/// turn with it.
//final class BoundsScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let sides: [Scalar] = [200, 300, 400]
//        let turns: [Scalar] = [0.25, 0.5, 1]       // fraction of a full turn
//        
//        
//        
//        for index in 0..<3 {
//            let half = sides[index] / 2
//            
//            
//            
//            // The square, drawn centered on the local origin.
//            var path = BezierPath()
//            path.move(to: Point2D(x: -half, y: -half))
//            path.addLine(to: Point2D(x: half, y: -half))
//            path.addLine(to: Point2D(x: half, y: half))
//            path.addLine(to: Point2D(x: -half, y: half))
//            path.close()
//            
//            let square = ShapeNode(path: path, fillColor: .white)
//            square.position.setValue(Point2D(x: -1000 + Scalar(index) * 1000, y: 0))
//            square.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            square.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: turns[index] * 2 * .pi)))
//            
//            
//            
//            // Local bounds: a red outline, as a child so it shares the square's space.
//            if let bounds = square.getLocalBounds(at: 0) {
//                let outline = PathNode(
//                    path: self.makeRectanglePath(bounds),
//                    strokeColor: Color(red: 1, green: 0.3, blue: 0.3),
//                    strokeWidth: 8
//                )
//                square.addChild(outline)
//            }
//            
//            
//            
//            // Local origin: a red dot at (0, 0), now the square's center.
//            let origin = Circle(radius: 16, fillColor: Color(red: 1, green: 0.3, blue: 0.3))
//            square.addChild(origin)
//            
//            
//            
//            self.addChild(square)
//        }
//    }
//    
//    
//    
//    
//    private func makeRectanglePath(_ rect: Rect2D) -> BezierPath {
//        let minX = rect.origin.x
//        let minY = rect.origin.y
//        let maxX = minX + rect.size.width
//        let maxY = minY + rect.size.height
//        
//        var path = BezierPath()
//        path.move(to: Point2D(x: minX, y: minY))
//        path.addLine(to: Point2D(x: maxX, y: minY))
//        path.addLine(to: Point2D(x: maxX, y: maxY))
//        path.addLine(to: Point2D(x: minX, y: maxY))
//        path.close()
//        return path
//    }
//}
//






/// Three squares drawn away from their node's origin. A red dot marks each
/// origin and a blue dot marks each anchor. Each node turns once around its
/// anchor: the left anchor is the origin, the middle is the square's center,
/// and the right is the square's far corner.
//final class OriginScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let side: Scalar = 200
//        
//        // Where each square's bottom-left corner sits in its node's own space.
//        let corners = [
//            Point2D(x: 100, y: 100),        // up and to the right of the origin
//            Point2D(x: -100, y: 150),       // above the origin
//            Point2D(x: -350, y: -100)       // to the left of the origin
//        ]
//        
//        // Each square's anchor, in its node's own space.
//        let anchors = [
//            Point2D(x: 0, y: 0),                                            // the origin (default)
//            Point2D(x: corners[1].x + side / 2, y: corners[1].y + side / 2), // the square's center
//            Point2D(x: corners[2].x + side, y: corners[2].y + side)          // the square's top-right corner
//        ]
//        
//        
//        
//        for index in 0..<3 {
//            let corner = corners[index]
//            let anchor = anchors[index]
//            
//            
//            
//            // The square, drawn away from the origin.
//            var path = BezierPath()
//            path.move(to: corner)
//            path.addLine(to: Point2D(x: corner.x + side, y: corner.y))
//            path.addLine(to: Point2D(x: corner.x + side, y: corner.y + side))
//            path.addLine(to: Point2D(x: corner.x, y: corner.y + side))
//            path.close()
//            
//            let square = ShapeNode(path: path, fillColor: .white)
//            square.anchor.setValue(anchor)
//            square.position.setValue(Point2D(x: -1100 + Scalar(index) * 1100, y: 0))
//            square.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            square.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: 2 * .pi)))
//            
//            
//            
//            // The origin: a red dot at (0, 0) in the square's own space.
//            let originMarker = Circle(radius: 30, fillColor: Color(red: 0, green: 1, blue: 1))
//            square.addChild(originMarker)
//            
//            // The anchor: a smaller blue dot, drawn on top, at the anchor point.
//            let anchorMarker = Circle(radius: 20, fillColor: Color(red: 1, green: 0, blue: 1))
//            anchorMarker.position.setValue(anchor)
//            square.addChild(anchorMarker)
//            
//            
//            
//            self.addChild(square)
//        }
//    }
//}






/// Three circles drawn away from their node's origin. A cyan dot marks each
/// origin and a magenta dot marks each anchor. Each node turns once around its
/// anchor: the left anchor is the origin, the middle is the circle's center, and
/// the right is the top of the circle's edge.
//final class OriginScene: SceneNode {
//
//
//
//
//    override func construct() {
//        
//        
//        
//        let radius: Scalar = 100
//        
//        // Where each circle's center sits in its node's own space.
//        let centers = [
//            Point2D(x: 200, y: 200),        // up and to the right of the origin
//            Point2D(x: 0, y: 250),          // above the origin
//            Point2D(x: -250, y: 0)          // to the left of the origin
//        ]
//        
//        // Each circle's anchor, in its node's own space.
//        let anchors = [
//            Point2D(x: 0, y: 0),                                // the origin (default)
//            centers[1],                                         // the circle's center
//            Point2D(x: centers[2].x, y: centers[2].y + radius)  // the top of the circle's edge
//        ]
//        
//        
//        
//        for index in 0..<3 {
//            let anchor = anchors[index]
//            
//            
//            
//            // The circle, drawn away from the origin.
//            let circle = ShapeNode(path: self.makeCirclePath(center: centers[index], radius: radius), fillColor: .white)
//            circle.anchor.setValue(anchor)
//            circle.position.setValue(Point2D(x: -1100 + Scalar(index) * 1100, y: 0))
//            circle.rotation.setKeyframe(Keyframe(frame: 0, value: Angle(radians: 0), easing: .easeInOut))
//            circle.rotation.setKeyframe(Keyframe(frame: 120, value: Angle(radians: 2 * .pi)))
//            
//            
//            
//            // The origin: a cyan dot at (0, 0) in the circle's own space.
//            let originMarker = Circle(radius: 30, fillColor: Color(red: 0, green: 1, blue: 1))
//            circle.addChild(originMarker)
//            
//            // The anchor: a smaller magenta dot, drawn on top, at the anchor point.
//            let anchorMarker = Circle(radius: 20, fillColor: Color(red: 1, green: 0, blue: 1))
//            anchorMarker.position.setValue(anchor)
//            circle.addChild(anchorMarker)
//            
//            
//            
//            self.addChild(circle)
//        }
//    }
//    
//    
//    
//    
//    /// A circle around `center`, made of four cubic curves, one per quarter.
//    private func makeCirclePath(center: Point2D, radius: Scalar) -> BezierPath {
//        // How far each control point sits from its curve's end, for a quarter
//        // circle drawn with one cubic curve.
//        let controlDistance = radius * 0.5522847498
//        
//        let right = Point2D(x: center.x + radius, y: center.y)
//        let top = Point2D(x: center.x, y: center.y + radius)
//        let left = Point2D(x: center.x - radius, y: center.y)
//        let bottom = Point2D(x: center.x, y: center.y - radius)
//        
//        var path = BezierPath()
//        path.move(to: right)
//        path.addCurve(to: top,
//                      controlPoint1: Point2D(x: right.x, y: right.y + controlDistance),
//                      controlPoint2: Point2D(x: top.x + controlDistance, y: top.y))
//        path.addCurve(to: left,
//                      controlPoint1: Point2D(x: top.x - controlDistance, y: top.y),
//                      controlPoint2: Point2D(x: left.x, y: left.y + controlDistance))
//        path.addCurve(to: bottom,
//                      controlPoint1: Point2D(x: left.x, y: left.y - controlDistance),
//                      controlPoint2: Point2D(x: bottom.x - controlDistance, y: bottom.y))
//        path.addCurve(to: right,
//                      controlPoint1: Point2D(x: bottom.x + controlDistance, y: bottom.y),
//                      controlPoint2: Point2D(x: right.x, y: right.y - controlDistance))
//        path.close()
//        return path
//    }
//}




/// A turned square with a dot on each corner of its bounds and one on the center.
final class PointsScene: SceneNode {




    override func construct() {
        
        
        
        var path = BezierPath()
        path.move(to: Point2D(x: -200, y: -200))
        path.addLine(to: Point2D(x: 200, y: -200))
        path.addLine(to: Point2D(x: 200, y: 200))
        path.addLine(to: Point2D(x: -200, y: 200))
        path.close()
        
        let square = ShapeNode(path: path, fillColor: .white)
        square.scale.setValue(Scale2D(scaleX: 2.0, scaleY: 2.0))
        square.anchor.setValue(Point2D(x: 100, y: 100))
        self.addChild(square)
        
        
        
        // The center, edge middles and corners of the square's bounds, in its own space.
        let bounds = square.getContentBounds(at: 0)
        let points = [
            bounds.center,
            bounds.top, bounds.bottom, bounds.left, bounds.right,
            bounds.topLeft, bounds.topRight, bounds.bottomLeft, bounds.bottomRight
        ]
        
        
        
        
        
        
        for point in points {
            let dot = Circle(radius: 25, fillColor: Color(red: 0.75, green: 0.25, blue: 0.5))
            dot.position.setValue(square.convertToWorld(point, at: 0))
            self.addChild(dot)
        }
        
        
        
        
        let squareAnchorPoint = square.anchor.getValue(at: 0)
        
        let anchorMarker = Circle(radius: 25, fillColor: Color(red: 0.25, green: 0.75, blue: 0.5))
        
        anchorMarker.position.setValue(square.convertToWorld(squareAnchorPoint, at: 0))
        
        
        
        self.addChild(anchorMarker)
    }
}





//do {
//    let folder = try SceneRenderer().render(TransformScene(name: "TransformScene"), to: .desktopDirectory)
//    print("Rendered TransformScene to \(folder.path)")
//} catch {
//    print("Rendering failed: \(error)")
//}



//do {
//    let folder = try SceneRenderer().render(AnchorScene(name: "AnchorScene"), to: .desktopDirectory)
//    print("Rendered AnchorScene to \(folder.path)")
//} catch {
//    print("Rendering failed: \(error)")
//}




//do {
//    let folder = try SceneRenderer().render(LineAnchorScene(name: "LineAnchorScene"), to: .desktopDirectory)
//    print("Rendered LineAnchorScene to \(folder.path)")
//} catch {
//    print("Rendering failed: \(error)")
//}



//do {
//    let folder = try SceneRenderer().render(BoundsScene(name: "BoundsScene"), to: .desktopDirectory)
//    print("Rendered BoundsScene to \(folder.path)")
//} catch {
//    print("Rendering failed: \(error)")
//}



//do {
//    let folder = try SceneRenderer().render(OriginScene(name: "OriginScene"), to: .desktopDirectory)
//    print("Rendered OriginScene to \(folder.path)")
//} catch {
//    print("Rendering failed: \(error)")
//}



do {
    let folder = try SceneRenderer().render(PointsScene(name: "PointsScene"), to: .desktopDirectory)
    print("Rendered PointsScene to \(folder.path)")
} catch {
    print("Rendering failed: \(error)")
}





