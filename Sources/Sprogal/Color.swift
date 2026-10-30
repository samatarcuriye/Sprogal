/// A backend-independent RGBA color. Each component runs from 0 to 1.
public struct Color {

    public let red: Scalar

    public let green: Scalar

    public let blue: Scalar

    public let alpha: Scalar

    public init(red: Scalar, green: Scalar, blue: Scalar, alpha: Scalar = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    
}




extension Color: Sendable {
    /// A backend-independent RGBA color. Each component runs from 0 to 1.
    

    public static let black = Color(red: 0, green: 0, blue: 0)

    public static let white = Color(red: 1, green: 1, blue: 1)

}
