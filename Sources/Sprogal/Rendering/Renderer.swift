import Foundation





// MARK: - Declaration

/// The base class for rendering a scene frame by frame.
///
/// Subclasses override `makeCanvas(forFrame:scene:)` to provide
/// a canvas for each frame. The base `render` method handles
/// scene construction, timeline preparation, and the frame loop.
open class Renderer {
    
    
    
    
    
    /// Creates a renderer.
    public init() {}
    
    
    
    
    
    /// Renders the scene frame by frame.
    ///
    /// Constructs the scene, prepares the timeline, then iterates
    /// through each frame, updating the scene, evaluating bindings,
    /// and rendering into a canvas provided by `makeCanvas(forFrame:scene:)`.
    ///
    /// A precondition failure occurs if `fps` is not positive.
    /// - Parameters:
    ///   - scene: The scene to render.
    ///   - fps: The frame rate in frames per second.
    public func render(scene: Scene, fps: Int) throws {
        precondition(fps > 0, "Frame rate must be positive.")
        
        scene.construct()
        scene.timeline.prepare()
        
        let totalFrames = Int(scene.timeline.duration.value * Double(fps))
        
        for frameNumber in 0...totalFrames {
            let currentTime = Scalar(Double(frameNumber) / Double(fps))
            let canvas = try self.makeCanvas(forFrame: frameNumber, scene: scene)
            
            scene.update(at: currentTime)
            scene.evaluateBindings()
            try scene.render(in: canvas)
        }
    }
    
    
    
    
    
    /// Creates a canvas for the given frame.
    ///
    /// Subclasses must override this to provide a canvas.
    /// The default implementation throws
    /// `RendererError.canvasNotProvided`.
    /// - Parameters:
    ///   - frameNumber: The current frame number.
    ///   - scene: The scene being rendered.
    /// - Returns: A canvas to render into.
    open func makeCanvas(forFrame frameNumber: Int, scene: Scene) throws -> Canvas {
        throw RendererError.canvasNotProvided(frame: frameNumber)
    }
    
    
    
    
    
}





// MARK: - RendererError

/// Errors that can occur during rendering.
extension Renderer {
    
    
    
    
    
    /// Errors specific to the renderer.
    public enum RendererError: Error {
        
        
        
        
        
        /// No canvas was provided for the given frame.
        case canvasNotProvided(frame: Int)
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - LocalizedError

/// Provides human-readable descriptions for renderer errors.
extension Renderer.RendererError: LocalizedError {
    
    
    
    
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .canvasNotProvided(let frame):
            return "No canvas provided for frame \(frame). Subclass Renderer and override makeCanvas(forFrame:scene:)."
        }
    }
    
    
    
    
    
}
