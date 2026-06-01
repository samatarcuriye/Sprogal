import Foundation





// MARK: - Declaration

/// A node that serves as a container for grouping child nodes.
///
/// A group has no visual content of its own. It provides a shared
/// coordinate space, transform, and opacity for its children,
/// allowing them to be moved, rotated, scaled, and faded as a unit.
open class Group: Node {
    
    
    
    
    
    /// Creates a group populated with child nodes.
    /// - Parameter children: The child nodes to add to the group.
    public init(_ children: [Node]) {
        super.init()
        for child in children {
            super.addChild(child)
        }
    }
    
    
    
    
    
    /// The combined bounds of all children in the group's
    /// local coordinate space.
    /// Returns a zero-size rect at the origin if the group
    /// has no children.
    open override func computeLocalBounds() -> Rect {
        guard !self.children.isEmpty else {
            return Rect(size: Size(width: 0, height: 0))
        }
        
        var allCorners: [Point] = []
        for child in self.children {
            let childPosition = child.currentLocalPosition
            for corner in child.localBounds.corners {
                allCorners.append(Point(
                    x: childPosition.x + corner.x,
                    y: childPosition.y + corner.y
                ))
            }
        }
        
        return Rect(containing: allCorners)
    }
    
    
    
    
    
}

