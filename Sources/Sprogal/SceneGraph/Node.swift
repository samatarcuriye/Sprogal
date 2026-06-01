import Foundation





// MARK: - Declaration

/// The base class for all elements in the scene graph.
///
/// A node has animatable properties (position, scale, rotation, opacity, size),
/// a pivot point for transforms, a z-index for draw ordering, and can contain
/// child nodes forming a tree hierarchy.
open class Node {
    
    
    
    
    
    /// The display name of this node, defaulting to the class name.
    public let name: String
    
    
    
    
    
    /// The child nodes in this node's subtree.
    public internal(set) var children: [Node] = []
    
    
    
    
    
    /// The parent node, or `nil` if this is a root node.
    public internal(set) weak var parent: Node?
    
    
    
    
    
    /// The node's position relative to its parent's origin.
    public internal(set) var position: Track<Point>
    
    
    
    
    
    /// The node's scale factor, where `(1, 1)` is the original size.
    public internal(set) var scale: Track<Vector>
    
    
    
    
    
    /// The node's shear factor, where `(0, 0)` is no shear.
    public internal(set) var shear: Track<Vector>
    
    
    
    
    
    /// The node's rotation angle around the pivot point.
    public internal(set) var rotation: Track<Angle>
    
    
    
    
    
    /// The node's opacity, from `0` (transparent) to `1` (opaque).
    public internal(set) var opacity: Track<Scalar>
    
    
    
    
    
    /// The node's intrinsic dimensions.
    public internal(set) var size: Track<Size>
    
    
    
    
    
    /// The point around which rotation and scale are applied, in local coordinates.
    /// Defaults to `(0, 0)`, which is the center of the node.
    public internal(set) var pivot: Point
    
    
    
    
    
    /// The draw order among siblings. Higher values render on top.
    public internal(set) var zIndex: Int
    
    
    
    
    
    /// The active bindings on this node.
    private var bindings: [Binding] = []
    
    
    
    
    
    /// Creates a node with default property values.
    ///
    /// The name defaults to the class name (e.g. `Node`, `Scene`).
    /// Position, rotation, and pivot default to zero. Scale defaults to `(1, 1)`.
    /// Opacity defaults to `1`. Size defaults to `(0, 0)`.
    public init() {
        self.name = String(describing: type(of: self))
        self.size = Track(Size(width: 0, height: 0))
        self.position = Track(Point(x: 0, y: 0))
        self.scale = Track(Vector(dx: 1, dy: 1))
        self.shear = Track(Vector(dx: 0, dy: 0))
        self.rotation = Track(Angle(radians: 0))
        self.opacity = Track(1)
        self.pivot = Point(x: 0, y: 0)
        self.zIndex = 0
    }
    
    
    
    
    
    /// Computes the local transform from this node's position, rotation, scale, and pivot.
    ///
    /// The transform order is: translate to position, then apply
    /// rotation and scale around the pivot point.
    ///
    /// Subclasses can override this to provide a custom local transform
    /// (e.g. `Camera` returns the inverse to implement view transformation).
    /// - Returns: The local transform.
    open func computeLocalTransform() -> Transform {
        let positionTransform = self.computePositionTransform()
        let pivotTransform = self.computePivotTransform()
        return positionTransform.concatenate(with: pivotTransform)
    }
    
    
    
    
    
    /// Computes the node's bounding rectangle in local coordinates, centered at the origin.
    /// Subclasses can override this to provide custom bounds (e.g. `Group`).
    /// - Returns: The local bounding rectangle.
    open func computeLocalBounds() -> Rect {
        let currentSize = self.size.current
        let halfWidth = currentSize.width * 0.5
        let halfHeight = currentSize.height * 0.5
        return Rect(
            origin: Point(x: -halfWidth, y: -halfHeight),
            size: currentSize
        )
    }
    
    
    
    
    
    /// Override this method in subclasses to perform custom drawing.
    /// - Parameter canvas: The canvas to draw into.
    open func draw(in canvas: Canvas) throws {}
    
    
    
    
    
    /// Evaluates all animated tracks at the given time, updating their `current` values,
    /// then recursively updates all children.
    ///
    /// Subclasses can override this to update additional tracks.
    /// Always call `super.update(at:)` first.
    /// - Parameter time: The time to evaluate at.
    open func update(at time: Scalar) {
        self.position.update(at: time)
        self.scale.update(at: time)
        self.shear.update(at: time)
        self.rotation.update(at: time)
        self.opacity.update(at: time)
        self.size.update(at: time)
        
        for child in self.children {
            child.update(at: time)
        }
    }
    
    
    
    
    
    /// Evaluates all bindings on this node, then recursively
    /// evaluates bindings on all children.
    ///
    /// Called each frame after `update(at:)` and before
    /// `render(in:)` to ensure bindings reflect the latest
    /// track values.
    open func evaluateBindings() {
        for binding in self.bindings {
            binding.apply()
        }
        for child in self.children {
            child.evaluateBindings()
        }
    }
    
    
    
    
    
    /// Renders this node and its children into the canvas.
    ///
    /// Applies the local transform (position, pivot, rotation, scale),
    /// sets opacity with a transparency layer, calls `draw(in:)`,
    /// then recursively renders children sorted by `zIndex`.
    /// - Parameter canvas: The canvas to render into.
    public func render(in canvas: Canvas) throws {
        canvas.saveState()
        
        self.applyTransform(to: canvas)
        self.applyOpacity(to: canvas)
        
        canvas.beginTransparencyLayer()
        try self.draw(in: canvas)
        try self.renderChildren(in: canvas)
        canvas.endTransparencyLayer()
        
        canvas.restoreState()
    }
    
    
    
    
    
    /// Adds a child node to this node's subtree.
    ///
    /// If the child already has a parent, it is removed from the old parent first.
    /// A precondition failure occurs if the child is the same instance as this node
    /// or if the child is an ancestor of this node, which would create a cycle.
    ///
    /// Subclasses can override this to perform additional work when children
    /// are added (e.g. recentering in `Group`). Always call `super.addChild(_:)`.
    /// - Parameter child: The node to add as a child.
    open func addChild(_ child: Node) {
        precondition(child !== self, "A node cannot be its own child.")
        precondition(!self.isDescendant(of: child), "Adding this child would create a cycle in the node hierarchy.")
        child.parent?.removeChild(child)
        child.parent = self
        self.children.append(child)
    }
    
    
    
    
    
    /// Removes a specific child node from this node's subtree.
    ///
    /// Subclasses can override this to perform additional work when children
    /// are removed (e.g. recentering in `Group`). Always call `super.removeChild(_:)`.
    /// - Parameter child: The child node to remove.
    /// - Returns: `true` if the child was found and removed, `false` otherwise.
    @discardableResult
    open func removeChild(_ child: Node) -> Bool {
        guard let index = self.children.firstIndex(where: { $0 === child }) else {
            return false
        }
        self.children.remove(at: index)
        child.parent = nil
        return true
    }
    
    
    
    
    
    /// Removes all child nodes from this node's subtree.
    ///
    /// Subclasses can override this to perform additional work when children
    /// are removed. Always call `super.removeAllChildren()`.
    open func removeAllChildren() {
        for child in self.children {
            child.parent = nil
        }
        self.children.removeAll()
    }
    
    
    
    
    
    /// Computes the position that would place this node adjacent to a target node
    /// in the given direction.
    ///
    /// Uses the bounds edges of both nodes, so the placement
    /// works correctly regardless of origin position.
    /// - Parameters:
    ///   - target: The node to place next to.
    ///   - direction: A unit vector indicating the direction of placement.
    ///   - spacing: The gap between the two nodes. Defaults to `0`.
    /// - Returns: The position point for this node.
    private func computePlacementPoint(nextTo target: Node, direction: Vector, spacing: Scalar = 0) -> Point {
        precondition(target !== self, "A node cannot be placed next to itself.")
        let targetBounds = target.localBounds
        let selfBounds = self.localBounds
        let targetPosition = target.currentLocalPosition
        
        let offsetX: Scalar
        let offsetY: Scalar
        
        if direction.dx.value > 0 {
            offsetX = targetPosition.x + targetBounds.maxX - selfBounds.minX + spacing
        } else if direction.dx.value < 0 {
            offsetX = targetPosition.x + targetBounds.minX - selfBounds.maxX - spacing
        } else {
            offsetX = targetPosition.x
        }
        
        if direction.dy.value > 0 {
            offsetY = targetPosition.y + targetBounds.maxY - selfBounds.minY + spacing
        } else if direction.dy.value < 0 {
            offsetY = targetPosition.y + targetBounds.minY - selfBounds.maxY - spacing
        } else {
            offsetY = targetPosition.y
        }
        
        return Point(x: offsetX, y: offsetY)
    }
    
    
    
    
    
    /// Computes the position that would align this node's edge with a target node's
    /// corresponding edge in the given direction.
    ///
    /// Uses the bounds edges of both nodes, so the alignment
    /// works correctly regardless of origin position.
    /// - Parameters:
    ///   - target: The node to align with.
    ///   - direction: A unit vector indicating which edge to align.
    ///   - spacing: The inset from the aligned edge. Defaults to `0`.
    /// - Returns: The position point for this node.
    private func computeAlignmentPoint(to target: Node, direction: Vector, spacing: Scalar = 0) -> Point {
        precondition(target !== self, "A node cannot be aligned to itself.")
        let targetBounds = target.localBounds
        let selfBounds = self.localBounds
        let targetPosition = target.currentLocalPosition
        
        let offsetX: Scalar
        let offsetY: Scalar
        
        if direction.dx.value > 0 {
            offsetX = targetPosition.x + targetBounds.maxX - selfBounds.maxX - spacing
        } else if direction.dx.value < 0 {
            offsetX = targetPosition.x + targetBounds.minX - selfBounds.minX + spacing
        } else {
            offsetX = targetPosition.x
        }
        
        if direction.dy.value > 0 {
            offsetY = targetPosition.y + targetBounds.maxY - selfBounds.maxY - spacing
        } else if direction.dy.value < 0 {
            offsetY = targetPosition.y + targetBounds.minY - selfBounds.minY + spacing
        } else {
            offsetY = targetPosition.y
        }
        
        return Point(x: offsetX, y: offsetY)
    }
    
    
    
    
    
}





// MARK: - Tween Builder

/// Provides access to a tween builder for animating this node's properties.
extension Node {
    
    
    
    
    
    /// A new builder for creating tweens that animate this
    /// node's properties.
    public var tween: TweenBuilder {
        return TweenBuilder(node: self)
    }
    
    
    
    
    
}





// MARK: - Current Local Properties

/// Accessors for the node's current property values in its parent's coordinate space.
extension Node {
    
    
    
    
    
    /// The node's current position in its parent's coordinate space.
    public var currentLocalPosition: Point {
        return self.computeLocalPosition()
    }
    
    
    
    
    
    /// The node's current scale factor in its parent's coordinate space.
    public var currentLocalScale: Vector {
        return self.computeLocalScale()
    }
    
    
    
    
    
    /// The node's current shear factor in its parent's coordinate space.
    public var currentLocalShear: Vector {
        return self.computeLocalShear()
    }
    
    
    
    
    
    /// The node's current rotation angle in its parent's coordinate space.
    public var currentLocalRotation: Angle {
        return self.computeLocalRotation()
    }
    
    
    
    
    
}





// MARK: - Current World Properties

/// Accessors for the node's current property values in world coordinates.
extension Node {
    
    
    
    
    
    /// The node's current position in world coordinates.
    public var currentWorldPosition: Point {
        return self.computeWorldPosition()
    }
    
    
    
    
    
    /// The node's current accumulated scale in world coordinates.
    public var currentWorldScale: Vector {
        return self.computeWorldScale()
    }
    
    
    
    
    
    /// The node's current accumulated rotation in world coordinates.
    public var currentWorldRotation: Angle {
        return self.computeWorldRotation()
    }
    
    
    
    
    
}





// MARK: - Current Intrinsic Properties

/// Accessors for the node's current intrinsic property values.
extension Node {
    
    
    
    
    
    /// The node's current size, derived from its local bounds.
    public var currentSize: Size {
        return self.localBounds.size
    }
    
    
    
    
    
    /// The node's current opacity.
    public var currentOpacity: Scalar {
        return self.opacity.current
    }
    
    
    
    
    
}





// MARK: - Compute Local Properties

/// Methods for computing the node's current property values in its parent's coordinate space.
extension Node {
    
    
    
    
    
    /// Computes the node's current position in its parent's coordinate space.
    /// - Returns: The local position.
    public func computeLocalPosition() -> Point {
        return self.position.current
    }
    
    
    
    
    
    /// Computes the node's current scale factor in its parent's coordinate space.
    /// - Returns: The local scale.
    public func computeLocalScale() -> Vector {
        return self.scale.current
    }
    
    
    
    
    
    /// Computes the node's current shear factor in its parent's coordinate space.
    /// - Returns: The local shear.
    public func computeLocalShear() -> Vector {
        return self.shear.current
    }
    
    
    
    
    
    /// Computes the node's current rotation angle in its parent's coordinate space.
    /// - Returns: The local rotation.
    public func computeLocalRotation() -> Angle {
        return self.rotation.current
    }
    
    
    
    
    
}





// MARK: - Compute World Properties

/// Methods for computing the node's current property values in world coordinates.
extension Node {
    
    
    
    
    
    /// Computes the node's current position in world coordinates.
    /// - Returns: The world position.
    public func computeWorldPosition() -> Point {
        let world = self.worldTransform
        return Point(x: world.tx, y: world.ty)
    }
    
    
    
    
    
    /// Computes the node's current accumulated scale in world coordinates
    /// by decomposing the world transform matrix.
    /// - Returns: The world scale.
    public func computeWorldScale() -> Vector {
        let world = self.worldTransform
        let scaleX = Scalar(sqrt(world.a.value * world.a.value + world.b.value * world.b.value))
        let scaleY = Scalar(sqrt(world.c.value * world.c.value + world.d.value * world.d.value))
        return Vector(dx: scaleX, dy: scaleY)
    }
    
    
    
    
    
    /// Computes the node's current accumulated rotation in world coordinates
    /// by decomposing the world transform matrix.
    /// - Returns: The world rotation.
    public func computeWorldRotation() -> Angle {
        let world = self.worldTransform
        return Angle(radians: Scalar(atan2(world.b.value, world.a.value)))
    }
    
    
    
    
    
}





// MARK: - Transform

/// Computed transforms for local and world coordinate spaces.
extension Node {
    
    
    
    
    
    /// The node's local transform, delegating to `computeLocalTransform()`.
    public var localTransform: Transform {
        return self.computeLocalTransform()
    }
    
    
    
    
    
    /// The world transform, computed by concatenating all ancestor transforms
    /// with this node's local transform.
    public var worldTransform: Transform {
        guard let parent = self.parent else {
            return self.localTransform
        }
        return parent.worldTransform.concatenate(with: self.localTransform)
    }
    
    
    
    
    
}





// MARK: - Transform Helpers

/// Private helper methods for computing transform components.
extension Node {
    
    
    
    
    
    /// Computes a translation transform from the node's current position.
    private func computePositionTransform() -> Transform {
        let currentPosition = self.position.current
        return Transform.translate(by: Vector(dx: currentPosition.x, dy: currentPosition.y))
    }
    
    
    
    
    
    /// Computes a transform that applies rotation, scale, and shear around the pivot point.
    /// The pivot is a point in local coordinates used directly — no scaling by size.
    private func computePivotTransform() -> Transform {
        let currentScale = self.scale.current
        let currentShear = self.shear.current
        let currentRotation = self.rotation.current
        
        let toPivot = Transform.translate(by: Vector(dx: self.pivot.x, dy: self.pivot.y))
        let rotate = Transform.rotate(by: currentRotation)
        let scale = Transform.scale(by: currentScale)
        let shear = Transform.shear(by: currentShear)
        let fromPivot = Transform.translate(by: Vector(dx: -self.pivot.x, dy: -self.pivot.y))
        
        return toPivot
            .concatenate(with: rotate)
            .concatenate(with: scale)
            .concatenate(with: shear)
            .concatenate(with: fromPivot)
    }
    
    
    
    
    
}





// MARK: - Bounds

/// Bounding rectangle computations in local and world coordinates.
extension Node {
    
    
    
    
    
    /// The node's bounding rectangle in local coordinates, centered at the origin.
    public var localBounds: Rect {
        return self.computeLocalBounds()
    }
    
    
    
    
    
    /// The axis-aligned bounding box in world coordinates.
    public var worldBounds: Rect {
        return self.computeWorldBounds()
    }
    
    
    
    
    
    /// Computes the axis-aligned bounding box in world coordinates by transforming
    /// the four corners of `localBounds` through `worldTransform` and taking
    /// the min/max extents.
    /// - Returns: The world bounding rectangle.
    public func computeWorldBounds() -> Rect {
        let transform = self.worldTransform
        let worldCorners = self.localBounds.corners.map { transform.applied(to: $0) }
        return Rect(containing: worldCorners)
    }
    
    
    
    
    
}





// MARK: - Property Setters

/// Methods for replacing animated tracks with static values.
extension Node {
    
    
    
    
    
    /// Replaces the position track with a static value, removing any animations.
    /// - Parameter position: The new position in the parent's coordinate space.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setPosition(to position: Point) -> Self {
        self.position = Track(position)
        return self
    }
    
    
    
    
    
    /// Replaces the scale track with a static value, removing any animations.
    /// - Parameter scale: The new scale vector.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setScale(to scale: Vector) -> Self {
        self.scale = Track(scale)
        return self
    }
    
    
    
    
    
    /// Replaces the shear track with a static value, removing any animations.
    /// - Parameter shear: The new shear vector.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setShear(to shear: Vector) -> Self {
        self.shear = Track(shear)
        return self
    }
    
    
    
    
    
    /// Replaces the rotation track with a static value, removing any animations.
    /// - Parameter rotation: The new rotation angle.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setRotation(to rotation: Angle) -> Self {
        self.rotation = Track(rotation)
        return self
    }
    
    
    
    
    
    /// Replaces the opacity track with a static value, removing any animations.
    ///
    /// The opacity must be in the range `0` to `1`.
    /// A precondition failure occurs if the value falls outside that range.
    /// - Parameter opacity: The new opacity, from `0` to `1`.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setOpacity(to opacity: Scalar) -> Self {
        precondition(opacity >= 0 && opacity <= 1, "Opacity must be between 0 and 1.")
        self.opacity = Track(opacity)
        return self
    }
    
    
    
    
    
    /// Replaces the size track with a static value, removing any animations.
    /// - Parameter size: The new intrinsic size.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setSize(to size: Size) -> Self {
        self.size = Track(size)
        return self
    }
    
    
    
    
    
    /// Sets the draw order among siblings.
    ///
    /// Higher values render on top of lower values.
    /// - Parameter zIndex: The new draw order value.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setZIndex(to zIndex: Int) -> Self {
        self.zIndex = zIndex
        return self
    }
    
    
    
    
    
    /// Sets the pivot point around which rotation and scale are applied.
    /// - Parameter pivot: The new pivot point in local coordinates.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setPivot(to pivot: Point) -> Self {
        self.pivot = pivot
        return self
    }
    
    
    
    
    
}





// MARK: - Placement

/// Methods for positioning this node relative to another node.
extension Node {
    
    
    
    
    
    /// Places this node adjacent to another node in the given direction.
    ///
    /// The direction vector indicates which side of the target node to place against.
    /// For example, `(-1, 0)` places this node to the left of the target,
    /// `(0, 1)` places it above.
    /// Both nodes must share the same parent.
    /// - Parameters:
    ///   - target: The node to place next to.
    ///   - direction: A unit vector indicating the direction of placement.
    ///   - spacing: The gap between the two nodes. Defaults to `0`.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func place(nextTo target: Node, direction: Vector, spacing: Scalar = 0) -> Self {
        precondition(target !== self, "A node cannot be placed next to itself.")
        let destination = self.computePlacementPoint(nextTo: target, direction: direction, spacing: spacing)
        self.setPosition(to: destination)
        return self
    }
    
    
    
    
    
}





// MARK: - Alignment

/// Methods for aligning this node's edges with another node's edges.
extension Node {
    
    
    
    
    
    /// Aligns this node's edge with another node's corresponding edge.
    ///
    /// The direction vector indicates which edge to align.
    /// For example, `(-1, 0)` aligns left edges, `(0, 1)` aligns top edges,
    /// `(1, 1)` aligns top-right corners.
    /// Both nodes must share the same parent.
    /// - Parameters:
    ///   - target: The node to align with.
    ///   - direction: A unit vector indicating which edge to align.
    ///   - spacing: The inset from the aligned edge. Defaults to `0`.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func align(to target: Node, direction: Vector, spacing: Scalar = 0) -> Self {
        precondition(target !== self, "A node cannot be aligned to itself.")
        let destination = self.computeAlignmentPoint(to: target, direction: direction, spacing: spacing)
        self.setPosition(to: destination)
        return self
    }
    
    
    
    
    
}





// MARK: - Children Helpers

/// Private helper methods for child hierarchy management.
extension Node {
    
    
    
    
    
    /// Returns `true` if this node is a descendant of the given node.
    /// - Parameter ancestor: The node to check against.
    /// - Returns: `true` if `ancestor` is found in this node's parent chain.
    private func isDescendant(of ancestor: Node) -> Bool {
        var current = self.parent
        while let node = current {
            if node === ancestor {
                return true
            }
            current = node.parent
        }
        return false
    }
    
    
    
    
    
}





// MARK: - Render Helpers

/// Private helper methods used by the render pipeline.
extension Node {
    
    
    
    
    
    /// Applies position, pivot, rotation, scale, and shear to the canvas.
    private func applyTransform(to canvas: Canvas) {
        let currentPosition = self.position.current
        let currentScale = self.scale.current
        let currentShear = self.shear.current
        let currentRotation = self.rotation.current
        
        canvas.translate(x: currentPosition.x, y: currentPosition.y)
        canvas.translate(x: self.pivot.x, y: self.pivot.y)
        canvas.rotate(by: currentRotation)
        canvas.scale(x: currentScale.dx, y: currentScale.dy)
        canvas.shear(x: currentShear.dx, y: currentShear.dy)
        canvas.translate(x: -self.pivot.x, y: -self.pivot.y)
    }
    
    
    
    
    
    /// Applies the node's current opacity to the canvas.
    private func applyOpacity(to canvas: Canvas) {
        canvas.setAlpha(self.opacity.current)
    }
    
    
    
    
    
    /// Renders all children sorted by zIndex.
    private func renderChildren(in canvas: Canvas) throws {
        let sortedChildren = self.children.sorted { $0.zIndex < $1.zIndex }
        for child in sortedChildren {
            try child.render(in: canvas)
        }
    }
    
    
    
    
    
}





// MARK: - NodeError

/// Errors that can occur during node operations.
extension Node {
    
    
    
    
    
    /// Errors specific to node operations.
    public enum NodeError: Error {
        
        
        
        
        
        /// A child node with the given name was not found.
        case childNotFound(childName: String)
        
        
        
        
        
        /// Drawing failed for the given node.
        case drawFailed(nodeName: String, reason: String)
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - LocalizedError

/// Provides human-readable descriptions for node errors.
extension Node.NodeError: LocalizedError {
    
    
    
    
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .childNotFound(let childName):
            return "Child node '\(childName)' not found."
        case .drawFailed(let nodeName, let reason):
            return "Failed to draw node '\(nodeName)': \(reason)"
        }
    }
    
    
    
    
    
}





// MARK: - Binding

/// A closure that runs every frame to maintain a relationship.
extension Node {
    
    
    
    
    
    /// A binding that runs every frame after tracks are evaluated.
    ///
    /// Bindings persist until explicitly removed or the node is
    /// removed from the scene. Use them to maintain relationships
    /// between nodes, such as keeping one node positioned relative
    /// to another.
    public class Binding {
        
        
        
        
        
        /// The closure to run each frame.
        public let apply: () -> Void
        
        
        
        
        
        /// Creates a binding with the given closure.
        /// - Parameter apply: The closure to run each frame.
        internal init(apply: @escaping () -> Void) {
            self.apply = apply
        }
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - Binding Management

/// Methods for adding and removing bindings on a node.
extension Node {
    
    
    
    
    
    /// Adds a binding that runs every frame after tracks are evaluated.
    ///
    /// ```swift
    /// child.addBinding {
    ///     child.setOpacity(to: parent.currentOpacity)
    /// }
    /// ```
    ///
    /// - Parameter closure: The closure to run each frame.
    /// - Returns: The binding instance, which can be used to remove it later.
    @discardableResult
    public func addBinding(_ closure: @escaping () -> Void) -> Binding {
        let binding = Binding(apply: closure)
        self.bindings.append(binding)
        return binding
    }
    
    
    
    
    
    /// Removes a binding.
    /// - Parameter binding: The binding to remove.
    public func removeBinding(_ binding: Binding) {
        self.bindings.removeAll { $0 === binding }
    }
    
    
    
    
    
    /// Removes all bindings from this node.
    public func removeAllBindings() {
        self.bindings.removeAll()
    }
    
    
    
    
    
}

