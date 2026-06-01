import Foundation
import CoreGraphics
import ImageIO





// MARK: - Declaration

/// A `Canvas` subclass backed by a `CGContext`, rendering to an
/// in-memory bitmap that can be written to disk as a PNG.
open class CGCanvas: Canvas {
    
    
    
    
    
    /// The underlying Core Graphics context.
    public let context: CGContext
    
    
    
    
    
    /// The bitmap width in pixels.
    public let pixelWidth: Int
    
    
    
    
    
    /// The bitmap height in pixels.
    public let pixelHeight: Int
    
    
    
    
    
    /// The number of pixels per scene unit.
    public let sceneScale: Scalar
    
    
    
    
    
    /// Creates a bitmap canvas with the given pixel dimensions.
    ///
    /// Both dimensions must be positive. The scene scale must be positive.
    /// A precondition failure occurs if any value is zero or negative.
    /// - Parameters:
    ///   - width: The bitmap width in pixels.
    ///   - height: The bitmap height in pixels.
    ///   - sceneScale: The number of pixels per scene unit.
    ///     Defaults to `1`.
    /// - Throws: `CGCanvasError.contextCreationFailed`
    ///   if the context cannot be created.
    public init(width: Int, height: Int, sceneScale: Scalar = 1) throws {
        precondition(width > 0, "Canvas width must be positive.")
        precondition(height > 0, "Canvas height must be positive.")
        precondition(sceneScale > 0, "Scene scale must be positive.")
        
        self.pixelWidth = width
        self.pixelHeight = height
        self.sceneScale = sceneScale
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw CGCanvasError.contextCreationFailed(width: width, height: height)
        }
        
        self.context = context
        super.init()
    }
    
    
    
    
    
    /// Saves the current graphics state onto the context's stack.
    public override func saveState() {
        self.context.saveGState()
    }
    
    
    
    
    
    /// Restores the most recently saved graphics state.
    public override func restoreState() {
        self.context.restoreGState()
    }
    
    
    
    
    
    /// Translates the context's coordinate system.
    /// - Parameters:
    ///   - x: The horizontal translation.
    ///   - y: The vertical translation.
    public override func translate(x: Scalar, y: Scalar) {
        self.context.translateBy(x: CGFloat(x.value), y: CGFloat(y.value))
    }
    
    
    
    
    
    /// Rotates the context's coordinate system.
    /// - Parameter angle: The rotation angle.
    public override func rotate(by angle: Angle) {
        self.context.rotate(by: CGFloat(angle.radians.value))
    }
    
    
    
    
    
    /// Scales the context's coordinate system.
    /// - Parameters:
    ///   - x: The horizontal scale factor.
    ///   - y: The vertical scale factor.
    public override func scale(x: Scalar, y: Scalar) {
        self.context.scaleBy(x: CGFloat(x.value), y: CGFloat(y.value))
    }
    
    
    
    
    
    /// Shears the context's coordinate system.
    /// - Parameters:
    ///   - x: The horizontal shear factor.
    ///   - y: The vertical shear factor.
    public override func shear(x: Scalar, y: Scalar) {
        let shearTransform = CGAffineTransform(a: 1, b: CGFloat(y.value), c: CGFloat(x.value), d: 1, tx: 0, ty: 0)
        self.context.concatenate(shearTransform)
    }
    
    
    
    
    
    /// Sets the global alpha value for subsequent drawing operations.
    /// - Parameter opacity: The opacity value, from `0` to `1`.
    public override func setAlpha(_ opacity: Scalar) {
        self.context.setAlpha(CGFloat(opacity.value))
    }
    
    
    
    
    
    /// Begins a transparency layer in the context.
    public override func beginTransparencyLayer() {
        self.context.beginTransparencyLayer(auxiliaryInfo: nil)
    }
    
    
    
    
    
    /// Ends the current transparency layer in the context.
    public override func endTransparencyLayer() {
        self.context.endTransparencyLayer()
    }
    
    
    
    
    
}





// MARK: - Output

/// Methods for writing the canvas contents to disk.
extension CGCanvas {
    
    
    
    
    
    /// Writes the canvas contents to a PNG file.
    /// - Parameter path: The output file path.
    /// - Throws: `CGCanvasError.imageCreationFailed`
    ///   or `.fileWriteFailed`.
    public func writePNG(to path: String) throws {
        guard let cgImage = self.context.makeImage() else {
            throw CGCanvasError.imageCreationFailed
        }
        
        let url = URL(fileURLWithPath: path)
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            "public.png" as CFString,
            1,
            nil
        ) else {
            throw CGCanvasError.fileWriteFailed(path: path)
        }
        
        CGImageDestinationAddImage(destination, cgImage, nil)
        
        guard CGImageDestinationFinalize(destination) else {
            throw CGCanvasError.fileWriteFailed(path: path)
        }
    }
    
    
    
    
    
    /// Fills the entire canvas with a solid color.
    /// - Parameter color: The fill color.
    public func clear(color: Color) {
        self.context.saveGState()
        self.context.setFillColor(
            red: CGFloat(color.red.value),
            green: CGFloat(color.green.value),
            blue: CGFloat(color.blue.value),
            alpha: CGFloat(color.alpha.value)
        )
        self.context.fill(CGRect(x: 0, y: 0, width: self.pixelWidth, height: self.pixelHeight))
        self.context.restoreGState()
    }
    
    
    
    
    
}





// MARK: - Color Conversion

/// Helper for converting Sprogal colors to Core Graphics colors.
extension CGCanvas {
    
    
    
    
    
    /// Converts a `Color` into a `CGColor`.
    /// - Parameter color: The color to convert.
    /// - Returns: The equivalent Core Graphics color.
    public func buildCGColor(from color: Color) -> CGColor {
        return CGColor(
            red: CGFloat(color.red.value),
            green: CGFloat(color.green.value),
            blue: CGFloat(color.blue.value),
            alpha: CGFloat(color.alpha.value)
        )
    }
    
    
    
    
    
}





// MARK: - CGCanvasError

/// Errors that can occur during canvas operations.
extension CGCanvas {
    
    
    
    
    
    /// Errors specific to Core Graphics canvas operations.
    public enum CGCanvasError: Error {
        
        
        
        
        
        /// The `CGContext` could not be created with the given dimensions.
        case contextCreationFailed(width: Int, height: Int)
        
        
        
        
        
        /// A `CGImage` could not be created from the context.
        case imageCreationFailed
        
        
        
        
        
        /// The PNG file could not be written to the given path.
        case fileWriteFailed(path: String)
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - LocalizedError

/// Provides human-readable descriptions for canvas errors.
extension CGCanvas.CGCanvasError: LocalizedError {
    
    
    
    
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .contextCreationFailed(let width, let height):
            return "Failed to create CGContext with size \(width)x\(height)."
        case .imageCreationFailed:
            return "Failed to create CGImage from context."
        case .fileWriteFailed(let path):
            return "Failed to write PNG to '\(path)'."
        }
    }
    
    
    
    
    
}

