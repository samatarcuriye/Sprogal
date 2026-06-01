import Foundation





// MARK: - Declaration

/// A builder for creating tweens that animate a node's properties.
///
/// Methods are chainable — each returns `self` so multiple
/// animations can be configured in a single expression:
///
/// ```swift
/// node.tween
///     .setPosition(to: Point(x: 2, y: 0), duration: 1)
///     .setOpacity(to: 0, duration: 1)
/// ```
///
/// The builder accumulates tweens internally. Pass the builder
/// to ``Timeline/append(_:)`` to schedule all tweens together.
public class TweenBuilder {
    
    
    
    
    
    /// The node whose properties this builder animates.
    public let target: Node
    
    
    
    
    
    /// The tweens accumulated by this builder's chained calls.
    public private(set) var tweens: [Tween] = []
    
    
    
    
    
    /// Creates a tween builder for the given node.
    /// - Parameter node: The node to animate.
    public init(node: Node) {
        self.target = node
    }
    
    
    
    
    
    /// Adds a tween to this builder.
    ///
    /// Used by package extensions that add tween methods
    /// from outside the Sprogal module.
    /// - Parameter tween: The tween to add.
    public func addTween(_ tween: Tween) {
        self.tweens.append(tween)
    }
    
    
    
    
    
}





// MARK: - Transform

/// Tweens for animating a node's position, scale, shear, and rotation.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node's position to the given value.
    /// - Parameters:
    ///   - position: The destination position.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setPosition(to position: Point, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "position") { startTime in
            let endTime = startTime + duration
            let currentPosition = node.position.value(at: startTime)
            node.position.addKeyframe(Track<Point>.Keyframe(currentPosition, time: startTime, easing: .linear))
            node.position.addKeyframe(Track<Point>.Keyframe(position, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's scale to the given value.
    /// - Parameters:
    ///   - scale: The destination scale.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setScale(to scale: Vector, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "scale") { startTime in
            let endTime = startTime + duration
            let currentScale = node.scale.value(at: startTime)
            node.scale.addKeyframe(Track<Vector>.Keyframe(currentScale, time: startTime, easing: .linear))
            node.scale.addKeyframe(Track<Vector>.Keyframe(scale, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's shear to the given value.
    /// - Parameters:
    ///   - shear: The destination shear.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setShear(to shear: Vector, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "shear") { startTime in
            let endTime = startTime + duration
            let currentShear = node.shear.value(at: startTime)
            node.shear.addKeyframe(Track<Vector>.Keyframe(currentShear, time: startTime, easing: .linear))
            node.shear.addKeyframe(Track<Vector>.Keyframe(shear, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's rotation to the given value.
    /// - Parameters:
    ///   - rotation: The destination rotation.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setRotation(to rotation: Angle, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "rotation") { startTime in
            let endTime = startTime + duration
            let currentRotation = node.rotation.value(at: startTime)
            node.rotation.addKeyframe(Track<Angle>.Keyframe(currentRotation, time: startTime, easing: .linear))
            node.rotation.addKeyframe(Track<Angle>.Keyframe(rotation, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
}





// MARK: - Appearance

/// Tweens for animating a node's opacity and size.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node's opacity to the given value.
    /// - Parameters:
    ///   - opacity: The destination opacity.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setOpacity(to opacity: Scalar, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "opacity") { startTime in
            let endTime = startTime + duration
            let currentOpacity = node.opacity.value(at: startTime)
            node.opacity.addKeyframe(Track<Scalar>.Keyframe(currentOpacity, time: startTime, easing: .linear))
            node.opacity.addKeyframe(Track<Scalar>.Keyframe(opacity, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's size to the given value.
    /// - Parameters:
    ///   - size: The destination size.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setSize(to size: Size, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "size") { startTime in
            let endTime = startTime + duration
            let currentSize = node.size.value(at: startTime)
            node.size.addKeyframe(Track<Size>.Keyframe(currentSize, time: startTime, easing: .linear))
            node.size.addKeyframe(Track<Size>.Keyframe(size, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
}





// MARK: - Placement

/// Tweens for animating a node's position relative to another node.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node to a position adjacent to a target node
    /// in the given direction.
    /// - Parameters:
    ///   - target: The node to place next to.
    ///   - direction: A unit vector indicating the direction of placement.
    ///   - spacing: The gap between the two nodes. Defaults to `0`.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func place(nextTo target: Node, direction: Vector, spacing: Scalar = 0, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "position") { startTime in
            let targetPosition = target.position.value(at: startTime)
            let targetBounds = target.localBounds
            let selfBounds = node.localBounds
            
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
            
            let destination = Point(x: offsetX, y: offsetY)
            let endTime = startTime + duration
            let currentPosition = node.position.value(at: startTime)
            node.position.addKeyframe(Track<Point>.Keyframe(currentPosition, time: startTime, easing: .linear))
            node.position.addKeyframe(Track<Point>.Keyframe(destination, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
}





// MARK: - Alignment

/// Tweens for animating a node's position to align with another node.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node to a position that aligns its edge with
    /// a target node's corresponding edge.
    /// - Parameters:
    ///   - target: The node to align with.
    ///   - direction: A unit vector indicating which edge to align.
    ///   - spacing: The inset from the aligned edge. Defaults to `0`.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func align(to target: Node, direction: Vector, spacing: Scalar = 0, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "position") { startTime in
            let targetPosition = target.position.value(at: startTime)
            let targetBounds = target.localBounds
            let selfBounds = node.localBounds
            
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
            
            let destination = Point(x: offsetX, y: offsetY)
            let endTime = startTime + duration
            let currentPosition = node.position.value(at: startTime)
            node.position.addKeyframe(Track<Point>.Keyframe(currentPosition, time: startTime, easing: .linear))
            node.position.addKeyframe(Track<Point>.Keyframe(destination, time: endTime, easing: easing))
        }
        self.tweens.append(tween)
        return self
    }
    
    
    
    
    
}

