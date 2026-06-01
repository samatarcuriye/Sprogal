import Foundation





// MARK: - Declaration

/// The base class for all drawing surfaces.
///
/// `Canvas` defines the interface for coordinate transforms,
/// opacity control, and transparency layers. Subclasses provide
/// the actual drawing implementation.
///
/// ```swift
/// // Node uses Canvas — never a specific subclass
/// open func draw(in canvas: Canvas) throws {}
/// ```
open class Canvas {
    
    
    
    
    
    /// Creates a canvas.
    public init() {}
    
    
    
    
    
    /// Saves the current graphics state onto a stack.
    open func saveState() {}
    
    
    
    
    
    /// Restores the most recently saved graphics state.
    open func restoreState() {}
    
    
    
    
    
    /// Translates the coordinate system by the given amounts.
    /// - Parameters:
    ///   - x: The horizontal translation.
    ///   - y: The vertical translation.
    open func translate(x: Scalar, y: Scalar) {}
    
    
    
    
    
    /// Rotates the coordinate system by the given angle.
    /// - Parameter angle: The rotation angle.
    open func rotate(by angle: Angle) {}
    
    
    
    
    
    /// Scales the coordinate system by the given factors.
    /// - Parameters:
    ///   - x: The horizontal scale factor.
    ///   - y: The vertical scale factor.
    open func scale(x: Scalar, y: Scalar) {}
    
    
    
    
    
    /// Shears the coordinate system by the given factors.
    /// - Parameters:
    ///   - x: The horizontal shear factor.
    ///   - y: The vertical shear factor.
    open func shear(x: Scalar, y: Scalar) {}
    
    
    
    
    
    /// Sets the global alpha for subsequent drawing operations.
    /// - Parameter opacity: The opacity value, from `0` (transparent) to `1` (opaque).
    open func setAlpha(_ opacity: Scalar) {}
    
    
    
    
    
    /// Begins a transparency layer, grouping subsequent drawing operations
    /// so that opacity applies to the group as a whole.
    open func beginTransparencyLayer() {}
    
    
    
    
    
    /// Ends the current transparency layer.
    open func endTransparencyLayer() {}
    
    
    
    
    
}

