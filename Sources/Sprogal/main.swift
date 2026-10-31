

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






do {
    let folder = try SceneRenderer().render(PointsScene(name: "PointsScene"), to: .desktopDirectory)
    print("Rendered PointsScene to \(folder.path)")
} catch {
    print("Rendering failed: \(error)")
}





