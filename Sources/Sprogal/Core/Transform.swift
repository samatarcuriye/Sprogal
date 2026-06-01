import Foundation





// MARK: - Declaration

/// A 2D affine transform represented as a 3×2 matrix.
///
/// The matrix layout is:
/// ```
/// | a  b  0 |
/// | c  d  0 |
/// | tx ty 1 |
/// ```
public struct Transform {
    
    
    
    
    
    /// The scale/rotation component at row 0, column 0.
    public let a: Scalar
    
    
    
    
    
    /// The scale/rotation component at row 0, column 1.
    public let b: Scalar
    
    
    
    
    
    /// The scale/rotation component at row 1, column 0.
    public let c: Scalar
    
    
    
    
    
    /// The scale/rotation component at row 1, column 1.
    public let d: Scalar
    
    
    
    
    
    /// The horizontal translation component.
    public let tx: Scalar
    
    
    
    
    
    /// The vertical translation component.
    public let ty: Scalar
    
    
    
    
    
    /// Creates a transform with the given matrix components.
    /// - Parameters:
    ///   - a: The scale/rotation component at row 0, column 0.
    ///   - b: The scale/rotation component at row 0, column 1.
    ///   - c: The scale/rotation component at row 1, column 0.
    ///   - d: The scale/rotation component at row 1, column 1.
    ///   - tx: The horizontal translation component.
    ///   - ty: The vertical translation component.
    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar, tx: Scalar, ty: Scalar) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }
    
    
    
    
    
}





// MARK: - Sendable

/// Confirms that `Transform` is safe to share across concurrency domains.
extension Transform: Sendable {}





// MARK: - Factory Methods

/// Factory methods for creating common transforms.
extension Transform {
    
    
    
    
    
    /// The identity transform, which leaves points unchanged.
    public static let identity = Transform(
        a: 1, b: 0,
        c: 0, d: 1,
        tx: 0, ty: 0
    )
    
    
    
    
    
    /// Creates a translation transform that moves points by the given offset.
    /// - Parameter offset: The translation vector.
    /// - Returns: A translation transform.
    public static func translate(by offset: Vector) -> Transform {
        return Transform(
            a: 1, b: 0,
            c: 0, d: 1,
            tx: offset.dx, ty: offset.dy
        )
    }
    
    
    
    
    
    /// Creates a scale transform that multiplies coordinates by the given factors.
    /// - Parameter factor: A vector whose `dx` and `dy` are the horizontal and vertical scale factors.
    /// - Returns: A scale transform.
    public static func scale(by factor: Vector) -> Transform {
        return Transform(
            a: factor.dx, b: 0,
            c: 0, d: factor.dy,
            tx: 0, ty: 0
        )
    }
    
    
    
    
    
    /// Creates a rotation transform by the given angle around the origin.
    /// - Parameter angle: The rotation angle.
    /// - Returns: A rotation transform.
    public static func rotate(by angle: Angle) -> Transform {
        return Transform(
            a: angle.cos, b: angle.sin,
            c: -angle.sin, d: angle.cos,
            tx: 0, ty: 0
        )
    }
    
    
    
    
    
    /// Creates a shear transform that skews coordinates by the given factors.
    /// - Parameter factor: A vector whose `dx` is the horizontal shear
    ///   and `dy` is the vertical shear.
    /// - Returns: A shear transform.
    public static func shear(by factor: Vector) -> Transform {
        return Transform(
            a: 1, b: factor.dx,
            c: factor.dy, d: 1,
            tx: 0, ty: 0
        )
    }
    
    
    
    
    
}





// MARK: - Operations

/// Methods for combining and applying transforms.
extension Transform {
    
    
    
    
    
    /// Returns a new transform by multiplying this transform with another.
    ///
    /// The result applies `self` first, then `transform`.
    /// - Parameter transform: The transform to concatenate.
    /// - Returns: The combined transform.
    public func concatenate(with transform: Transform) -> Transform {
        return Transform(
            a: self.a * transform.a + self.b * transform.c,
            b: self.a * transform.b + self.b * transform.d,
            c: self.c * transform.a + self.d * transform.c,
            d: self.c * transform.b + self.d * transform.d,
            tx: self.a * transform.tx + self.b * transform.ty + self.tx,
            ty: self.c * transform.tx + self.d * transform.ty + self.ty
        )
    }
    
    
    
    
    
    /// Applies this transform to a point and returns the transformed point.
    /// - Parameter point: The point to transform.
    /// - Returns: The transformed point in the new coordinate space.
    public func applied(to point: Point) -> Point {
        return Point(
            x: self.a * point.x + self.b * point.y + self.tx,
            y: self.c * point.x + self.d * point.y + self.ty
        )
    }
    
    
    
    
    
    /// Returns the inverse of this transform.
    ///
    /// The inverse undoes the effect of this transform: applying
    /// a transform and then its inverse (or vice versa) yields
    /// the identity. Returns the identity if the transform is
    /// not invertible (zero determinant).
    /// - Returns: The inverse transform.
    public func inverted() -> Transform {
        let determinant = self.a * self.d - self.b * self.c
        
        guard abs(determinant) > Scalar(1e-12) else {
            return Transform.identity
        }
        
        let inverseDeterminant = Scalar(1) / determinant
        
        return Transform(
            a: self.d * inverseDeterminant,
            b: -self.b * inverseDeterminant,
            c: -self.c * inverseDeterminant,
            d: self.a * inverseDeterminant,
            tx: (self.b * self.ty - self.d * self.tx) * inverseDeterminant,
            ty: (self.c * self.tx - self.a * self.ty) * inverseDeterminant
        )
    }
    
    
    
    
    
}

