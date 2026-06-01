import Foundation





// MARK: - Declaration

/// A camera node that provides zooming, panning, and rotating
/// of the scene.
///
/// All scene content placed as children of the camera will be
/// affected by the camera's transform. Moving the camera right
/// makes the scene appear to move left. Scaling the camera up
/// zooms in. Rotating the camera rotates the scene in the
/// opposite direction.
///
/// The camera overrides `computeLocalTransform()` to return the inverse
/// of the normal transform, so the rendering pipeline applies
/// it automatically without special camera logic.
///
/// The camera's size defines its viewport — the visible region
/// in scene units. Set it to the scene's dimensions:
///
/// ```swift
/// let camera = Camera()
/// camera.setSize(to: Size(width: 14.22, height: 8))
/// scene.addChild(camera)
/// camera.addChild(node)
///
/// // Pan to the right
/// camera.tween.setPosition(to: Point(x: 5, y: 0), duration: 2)
///
/// // Zoom in 2x
/// camera.tween.setScale(to: Vector(dx: 2, dy: 2), duration: 1.5)
///
/// // Rotate
/// camera.tween.setRotation(to: Angle(radians: 0.26), duration: 1)
/// ```
public class Camera: Node {
    
    
    
    
    
    /// Returns the inverse of the normal local transform.
    ///
    /// This causes the rendering pipeline to apply the opposite
    /// of the camera's position, rotation, and scale to all
    /// children. Moving the camera right shifts children left,
    /// zooming the camera in scales children up, and rotating
    /// the camera clockwise rotates children counterclockwise.
    /// - Returns: The inverted local transform.
    public override func computeLocalTransform() -> Transform {
        let forward = super.computeLocalTransform()
        return forward.inverted()
    }
    
    
    
    
    
}





// MARK: - Viewport

/// Accessors for the camera's visible region.
extension Camera {
    
    
    
    
    
    /// The size of the visible area in scene units.
    ///
    /// Derived from the node's size track, so it is animatable
    /// via `setSize` and `tween.setSize`.
    public var viewportSize: Size {
        return self.size.current
    }
    
    
    
    
    
}





// MARK: - Visibility

/// Methods for testing whether points or nodes are within the camera's visible region.
extension Camera {
    
    
    
    
    
    /// Computes the axis-aligned bounding rectangle of the
    /// visible region in world coordinates.
    ///
    /// Takes the viewport rectangle centered at the origin,
    /// transforms its corners through the camera's forward
    /// transform (not the inverse), and returns the enclosing
    /// rectangle.
    /// - Returns: The visible region in world coordinates.
    public func computeViewportBounds() -> Rect {
        let halfWidth = self.viewportSize.width * 0.5
        let halfHeight = self.viewportSize.height * 0.5
        
        let forwardTransform = self.computeForwardTransform()
        
        let topLeft = forwardTransform.applied(to: Point(
            x: -halfWidth, y: halfHeight
        ))
        let topRight = forwardTransform.applied(to: Point(
            x: halfWidth, y: halfHeight
        ))
        let bottomLeft = forwardTransform.applied(to: Point(
            x: -halfWidth, y: -halfHeight
        ))
        let bottomRight = forwardTransform.applied(to: Point(
            x: halfWidth, y: -halfHeight
        ))
        
        return Rect(containing: [topLeft, topRight, bottomLeft, bottomRight])
    }
    
    
    
    
    
    /// Returns whether a point in world coordinates is within
    /// the camera's visible region.
    /// - Parameter point: The point to test.
    /// - Returns: `true` if the point is visible.
    public func computePointIsVisible(_ point: Point) -> Bool {
        return self.computeViewportBounds().contains(point)
    }
    
    
    
    
    
    /// Returns whether a node's world bounds intersect the
    /// camera's visible region.
    /// - Parameter node: The node to test.
    /// - Returns: `true` if any part of the node is visible.
    public func computeNodeIsVisible(_ node: Node) -> Bool {
        return self.computeViewportBounds().intersects(node.worldBounds)
    }
    
    
    
    
    
}





// MARK: - Forward Transform

/// Private helper for computing the camera's non-inverted transform.
extension Camera {
    
    
    
    
    
    /// Computes the camera's forward transform — position,
    /// rotation, and scale as a normal node, without inversion.
    ///
    /// Used by viewport calculations to map from screen space
    /// back to world space.
    /// - Returns: The forward local transform.
    private func computeForwardTransform() -> Transform {
        return super.computeLocalTransform()
    }
    
    
    
    
    
}
