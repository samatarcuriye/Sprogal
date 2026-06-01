import Foundation
import CoreGraphics





// MARK: - Declaration

/// A renderer that outputs each frame as a PNG file using
/// Core Graphics.
///
/// The renderer creates a subfolder named after the scene class
/// inside the output directory.
///
/// ```swift
/// let renderer = CGRenderer(outputDirectory: .desktop)
/// try renderer.render(
///     scene: MyScene(pixelSize: Size(width: 1920, height: 1080), scaledHeight: 8),
///     fps: 60
/// )
/// // Outputs to ~/Desktop/MyScene/frame0000.png ...
/// ```
open class CGRenderer: Renderer {
    
    
    
    
    
    /// The base output directory.
    private let outputDirectory: OutputDirectory
    
    
    
    
    
    /// Creates a renderer that writes PNG frames to the given directory.
    /// - Parameter outputDirectory: The base directory for output.
    public init(outputDirectory: OutputDirectory) {
        self.outputDirectory = outputDirectory
        super.init()
    }
    
    
    
    
    
    /// Renders the scene frame by frame, writing each as a
    /// numbered PNG file.
    ///
    /// Sets up a coordinate system with origin at center and
    /// Y-axis pointing up.
    /// - Parameters:
    ///   - scene: The scene to render.
    ///   - fps: The frame rate in frames per second.
    public override func render(scene: Scene, fps: Int) throws {
        let scenePath = self.computeScenePath(for: scene)
        
        try FileManager.default.createDirectory(
            atPath: scenePath,
            withIntermediateDirectories: true
        )
        
        scene.construct()
        scene.timeline.prepare()
        
        let pixelWidth = Int(scene.pixelSize.width.value)
        let pixelHeight = Int(scene.pixelSize.height.value)
        let totalFrames = Int(scene.timeline.duration.value * Double(fps))
        
        let logicalWidth = scene.logicalSize.width.value
        let logicalHeight = scene.logicalSize.height.value
        let scaleX = scene.pixelSize.width.value / logicalWidth
        let scaleY = scene.pixelSize.height.value / logicalHeight
        let sceneScale = Scalar(scaleY)
        
        for frameNumber in 0...totalFrames {
            let currentTime = Scalar(Double(frameNumber) / Double(fps))
            
            let canvas = try CGCanvas(
                width: pixelWidth,
                height: pixelHeight,
                sceneScale: sceneScale
            )
            canvas.clear(color: scene.backgroundColor)
            
            canvas.saveState()
            canvas.translate(
                x: Scalar(Double(pixelWidth) / 2),
                y: Scalar(Double(pixelHeight) / 2)
            )
            canvas.scale(x: Scalar(scaleX), y: Scalar(scaleY))
            
            scene.update(at: currentTime)
            scene.evaluateBindings()
            try scene.render(in: canvas)
            
            canvas.restoreState()
            
            let framePath = self.computeFramePath(scenePath: scenePath, frameNumber: frameNumber)
            try canvas.writePNG(to: framePath)
        }
    }
    
    
    
    
    
}





// MARK: - OutputDirectory

/// A well-known directory for renderer output.
extension CGRenderer {
    
    
    
    
    
    /// A base directory where the renderer writes frame images.
    ///
    /// The renderer creates a subfolder named after the scene
    /// class inside the chosen directory.
    public enum OutputDirectory {
        
        
        
        
        
        /// The user's Desktop folder.
        case desktop
        
        
        
        
        
        /// The user's Downloads folder.
        case downloads
        
        
        
        
        
        /// The user's Documents folder.
        case documents
        
        
        
        
        
        /// A custom directory path.
        case custom(String)
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - Path Resolution

/// Methods for resolving the output directory to a file system path.
extension CGRenderer.OutputDirectory {
    
    
    
    
    
    /// The absolute path to the directory.
    public var path: String {
        switch self {
        case .desktop:
            return self.resolveSearchPath(.desktopDirectory)
        case .downloads:
            return self.resolveSearchPath(.downloadsDirectory)
        case .documents:
            return self.resolveSearchPath(.documentDirectory)
        case .custom(let path):
            return path
        }
    }
    
    
    
    
    
    /// Resolves a macOS search path directory to an absolute path.
    ///
    /// A precondition failure occurs if the directory cannot be found.
    /// - Parameter directory: The search path directory.
    /// - Returns: The absolute path.
    private func resolveSearchPath(_ directory: FileManager.SearchPathDirectory) -> String {
        guard let url = FileManager.default.urls(
            for: directory,
            in: .userDomainMask
        ).first else {
            preconditionFailure("Could not resolve \(directory) directory.")
        }
        return url.path
    }
    
    
    
    
    
}





// MARK: - Path Computation

/// Private helpers for computing output paths.
extension CGRenderer {
    
    
    
    
    
    /// Computes the output directory path for a scene, using
    /// the scene's class name as the subfolder.
    /// - Parameter scene: The scene being rendered.
    /// - Returns: The full directory path.
    private func computeScenePath(for scene: Scene) -> String {
        let sceneName = String(describing: type(of: scene))
        return "\(self.outputDirectory.path)/\(sceneName)"
    }
    
    
    
    
    
    /// Returns the file path for a given frame number, zero-padded
    /// to four digits.
    /// - Parameters:
    ///   - scenePath: The scene's output directory.
    ///   - frameNumber: The frame number.
    /// - Returns: The full file path.
    private func computeFramePath(scenePath: String, frameNumber: Int) -> String {
        let paddedNumber = String(format: "%04d", frameNumber)
        return "\(scenePath)/frame\(paddedNumber).png"
    }
    
    
    
    
    
}
