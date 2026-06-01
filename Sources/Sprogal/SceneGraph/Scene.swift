import Foundation





// MARK: - Declaration

/// The root node of a scene graph, providing a background color,
/// timeline for animations, and a mapping between pixel and logical coordinates.
open class Scene: Node {
    
    
    
    
    
    /// The background color used to clear the canvas before rendering.
    ///
    /// Defaults to black. Set to a color with alpha `0` for a
    /// transparent background (useful for video overlays).
    public internal(set) var backgroundColor: Color
    
    
    
    
    
    /// The timeline that sequences all animations in the scene.
    public let timeline: Timeline
    
    
    
    
    
    /// The output resolution in pixels.
    public let pixelSize: Size
    
    
    
    
    
    /// Creates a scene that fits a given pixel size, scaling to a target logical height.
    ///
    /// The logical width is computed from the pixel aspect ratio.
    /// - Parameters:
    ///   - pixelSize: The output resolution in pixels.
    ///   - scaledHeight: The desired logical height.
    public init(pixelSize: Size, scaledHeight: Scalar) {
        let aspectRatio = pixelSize.width.value / pixelSize.height.value
        let scaledWidth = scaledHeight * Scalar(aspectRatio)
        let logicalSize = Size(width: scaledWidth, height: scaledHeight)
        
        self.backgroundColor = Color(red: 0, green: 0, blue: 0)
        self.timeline = Timeline()
        self.pixelSize = pixelSize
        super.init()
        self.setSize(to: logicalSize)
    }
    
    
    
    
    
    /// Creates a scene that fits a given pixel size, scaling to a target logical width.
    ///
    /// The logical height is computed from the pixel aspect ratio.
    /// - Parameters:
    ///   - pixelSize: The output resolution in pixels.
    ///   - scaledWidth: The desired logical width.
    public init(pixelSize: Size, scaledWidth: Scalar) {
        let aspectRatio = pixelSize.height.value / pixelSize.width.value
        let scaledHeight = scaledWidth * Scalar(aspectRatio)
        let logicalSize = Size(width: scaledWidth, height: scaledHeight)
        
        self.backgroundColor = Color(red: 0, green: 0, blue: 0)
        self.timeline = Timeline()
        self.pixelSize = pixelSize
        super.init()
        self.setSize(to: logicalSize)
    }
    
    
    
    
    
    /// Override this method to build the scene's node tree and schedule animations.
    open func construct() {}
    
    
    
    
    
}





// MARK: - Properties

/// Computed properties derived from the scene's configuration.
extension Scene {
    
    
    
    
    
    /// The logical size of the scene, derived from the current size track value.
    public var logicalSize: Size {
        return self.size.current
    }
    
    
    
    
    
}





// MARK: - Property Setters

/// Methods for setting scene properties.
extension Scene {
    
    
    
    
    
    /// Sets the background color used to clear the canvas before rendering.
    ///
    /// Set to a color with alpha `0` for a transparent background
    /// (useful for video overlays in Final Cut Pro or similar).
    /// - Parameter color: The new background color.
    /// - Returns: This scene, for chaining.
    @discardableResult
    public func setBackgroundColor(to color: Color) -> Self {
        self.backgroundColor = color
        return self
    }
    
    
    
    
    
}


