




open class Node {


    public var name: String? = nil

    public private(set) weak var parent: Node? = nil

    public private(set) var children: [Node] = []





    public let anchor = Track(Point2D(x: 0, y: 0))

    public let position = Track(Point2D(x: 0, y: 0))

    /// Rotation around the anchor. Positive angles turn counterclockwise.
    public let rotation = Track(Angle(radians: 0))

    /// Scale around the anchor. 1 is the node's own size.
    public let scale = Track(Scale2D(scaleX: 1, scaleY: 1))



    /// The box around what this node itself draws at `frame`, in its own space,
    /// not counting children. A node that draws nothing returns an empty box at its
    /// origin, so it acts as a single point. Override in nodes that draw.
    open func getContentBounds(at frame: Integer) -> Rect2D {
        return Rect2D(origin: Point2D(x: 0, y: 0), size: Size2D(width: 0, height: 0))
    }




    open var tracks: [Keyframable] {
        return [self.anchor, self.position, self.rotation, self.scale]
    }



    public var lastFrame: Integer? {
        let own = self.tracks.compactMap { $0.lastFrame }.max()
        let children = self.children.compactMap { $0.lastFrame }.max()
        return [own, children].compactMap { $0 }.max()
    }


    public init(name: String? = nil) {
        self.name = name
    }


    public func addChild(_ node: Node) {
        self.insertChild(node, at: self.children.count)
    }





    public func insertChild(_ node: Node, at index: Int) {
        precondition(node !== self, "A node cannot be a child of itself.")
        precondition(node.parent == nil, "Node already has a parent; call removeFromParent() first.")
        precondition(!self.isDescendant(of: node), "Cannot add an ancestor as a child; this would create a cycle.")
        precondition(index >= 0 && index <= self.children.count, "Index \(index) is out of range 0...\(self.children.count).")

        self.children.insert(node, at: index)
        node.parent = self
    }





    public func removeFromParent() {

        guard let parent = self.parent else { return }

        parent.children.removeAll { $0 === self }
        self.parent = nil
    }




    public func removeAllChildren() {
        for child in self.children { child.parent = nil }
        self.children.removeAll()
    }



    public func isDescendant(of node: Node) -> Bool {
        var nextAncestor = self.parent
        while let currentAncestor = nextAncestor {
            if currentAncestor === node { return true }
            nextAncestor = currentAncestor.parent
        }
        return false
    }



    public func isAncestor(of node: Node) -> Bool {
        return node.isDescendant(of: self)
    }




    /// The transform from this node's local space into its parent's space at `frame`.
    ///
    /// The anchor lands on `position`, and the node rotates and scales around
    /// its anchor.
    public func getLocalTransform(at frame: Integer) -> Transform2D {
        let position = self.position.getValue(at: frame)
        let anchor = self.anchor.getValue(at: frame)
        let rotation = self.rotation.getValue(at: frame)
        let scale = self.scale.getValue(at: frame)

        return Transform2D.identity
            .translated(by: Vector2D(dx: position.x, dy: position.y))
            .rotated(by: rotation)
            .scaled(by: scale)
            .translated(by: Vector2D(dx: -anchor.x, dy: -anchor.y))
    }





    
    
    /// The transform from this node's own space into world space at `frame`: the
    /// space the whole tree is drawn in, with its origin at the center of the frame.
    /// Combines this node's local transform with every ancestor's.
    public func getWorldTransform(at frame: Integer) -> Transform2D {
        let local = self.getLocalTransform(at: frame)
        guard let parent = self.parent else { return local }
        return local.concatenating(parent.getWorldTransform(at: frame))
    }

    
    
    
    public final func render(frame: Integer, in canvas: Canvas) {
        canvas.save()
        canvas.concatenate(with: self.getLocalTransform(at: frame))

        self.draw(frame: frame, in: canvas)

        for child in self.children {
            child.render(frame: frame, in: canvas)
        }

        canvas.restore()
    }





    open func draw(frame: Integer, in canvas: Canvas) {}





}






extension Node {
    
    
    
    
    
    public func convertToWorld(_ point: Point2D, at frame: Integer) -> Point2D {
        return self.getWorldTransform(at: frame).applying(to: point)
    }
    
    
    
    
    
}

