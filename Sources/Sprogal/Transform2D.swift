




import Foundation





/// A 2D affine transform, laid out the same way as `CGAffineTransform`.
///
/// `translated`, `scaled` and `rotated` all work in the transform's local space,
/// like their Core Graphics counterparts: each step is applied inside the steps
/// before it, so a chain reads in the order you'd describe it.
public struct Transform2D {




    public let a: Scalar



    public let b: Scalar



    public let c: Scalar



    public let d: Scalar




    public let tx: Scalar




    public let ty: Scalar




    public init(a: Scalar, b: Scalar, c: Scalar, d: Scalar, tx: Scalar, ty: Scalar) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }




    public static let identity = Transform2D(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)




    /// Moves by `vector` in local space: the vector is rotated and scaled by the
    /// existing transform. Matches `CGAffineTransform.translatedBy(x:y:)`.
    public func translated(by vector: Vector2D) -> Transform2D {
        return Transform2D(
            a: self.a,
            b: self.b,
            c: self.c,
            d: self.d,
            tx: self.a * vector.dx + self.c * vector.dy + self.tx,
            ty: self.b * vector.dx + self.d * vector.dy + self.ty
        )
    }




    /// Scales about the local origin, by `scale.scaleX` horizontally and
    /// `scale.scaleY` vertically. Matches `CGAffineTransform.scaledBy(x:y:)`.
    public func scaled(by scale: Scale2D) -> Transform2D {
        return Transform2D(
            a: self.a * scale.scaleX,
            b: self.b * scale.scaleX,
            c: self.c * scale.scaleY,
            d: self.d * scale.scaleY,
            tx: self.tx,
            ty: self.ty
        )
    }




    /// Scales uniformly about the local origin.
    public func scaled(by factor: Scalar) -> Transform2D {
        return self.scaled(by: Scale2D(scaleX: factor, scaleY: factor))
    }




    /// Rotates about the local origin. Positive angles turn counterclockwise in the
    /// scene's y-up space. Matches `CGAffineTransform.rotated(by:)`.
    public func rotated(by angle: Angle) -> Transform2D {
        let cosine = cos(angle.radians)
        let sine = sin(angle.radians)
        return Transform2D(
            a: cosine * self.a + sine * self.c,
            b: cosine * self.b + sine * self.d,
            c: cosine * self.c - sine * self.a,
            d: cosine * self.d - sine * self.b,
            tx: self.tx,
            ty: self.ty
        )
    }




    /// Moves `point` through the transform: from the space the transform maps
    /// from into the space it maps to.
    public func applying(to point: Point2D) -> Point2D {
        return Point2D(
            x: self.a * point.x + self.c * point.y + self.tx,
            y: self.b * point.x + self.d * point.y + self.ty
        )
    }




    /// A transform that applies this one first, then `other`. Matches
    /// `CGAffineTransform.concatenating(_:)`.
    public func concatenating(_ other: Transform2D) -> Transform2D {
        return Transform2D(
            a: self.a * other.a + self.b * other.c,
            b: self.a * other.b + self.b * other.d,
            c: self.c * other.a + self.d * other.c,
            d: self.c * other.b + self.d * other.d,
            tx: self.tx * other.a + self.ty * other.c + other.tx,
            ty: self.tx * other.b + self.ty * other.d + other.ty
        )
    }




    /// The transform that undoes this one, or `nil` if there is none. A transform
    /// that flattens space has no inverse, such as one with a scale of 0.
    public func inverted() -> Transform2D? {
        let determinant = self.a * self.d - self.b * self.c
        guard determinant != 0 else { return nil }
        return Transform2D(
            a: self.d / determinant,
            b: -self.b / determinant,
            c: -self.c / determinant,
            d: self.a / determinant,
            tx: (self.c * self.ty - self.d * self.tx) / determinant,
            ty: (self.b * self.tx - self.a * self.ty) / determinant
        )
    }
}





extension Transform2D: Sendable {}
