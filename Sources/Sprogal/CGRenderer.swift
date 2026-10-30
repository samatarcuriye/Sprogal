import CoreGraphics
import Foundation
import ImageIO





public final class SceneRenderer {




    public enum RenderError: Error {
        case couldNotCreateContext
        case couldNotCreateImage(frame: Integer)
        case couldNotWritePNG(URL)
    }




    public init() {}




    /// Renders every frame of `scene` as PNG files into a new folder inside a standard
    /// user directory such as `.desktopDirectory` or `.downloadsDirectory`.
    /// The animation runs from frame 0 to the last keyframe of the longest track.
    ///
    /// The folder is named `folderName`, or the scene's name, or "Frames".
    /// Returns the URL of the folder the frames were written to.
    @discardableResult
    public func render(
        _ scene: SceneNode,
        to directory: FileManager.SearchPathDirectory,
        folderName: String? = nil
    ) throws -> URL {
        let base = try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: false)
        return try self.render(scene, to: base, folderName: folderName)
    }




    /// Renders every frame of `scene` as PNG files into a new folder inside `directory`.
    /// The animation runs from frame 0 to the last keyframe of the longest track.
    ///
    /// The folder is named `folderName`, or the scene's name, or "Frames".
    /// Returns the URL of the folder the frames were written to.
    @discardableResult
    public func render(
        _ scene: SceneNode,
        to directory: URL,
        folderName: String? = nil
    ) throws -> URL {
        let frames = 0..<scene.frameCount
        let folder = directory.appendingPathComponent(folderName ?? scene.name ?? "Frames", isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let width = Int(scene.size.width)
        let height = Int(scene.size.height)
        let context = try self.makeContext(width: width, height: height)
        let canvas = CGCanvas(context: context)
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let digits = max(4, String(frames.upperBound - 1).count)

        for frame in frames {
            self.paintBackground(scene.backgroundColor, in: context, bounds: bounds)
            scene.renderFrame(frame, in: canvas)

            guard let image = context.makeImage() else {
                throw RenderError.couldNotCreateImage(frame: frame)
            }

            let fileName = "frame_" + self.padded(frame, to: digits) + ".png"
            try self.writePNG(image, to: folder.appendingPathComponent(fileName))
        }

        return folder
    }




    /// Clears the previous frame, then fills the whole image with `color`.
    ///
    /// Clearing first matters for a see-through color: without it, the previous
    /// frame would show through the new background.
    private func paintBackground(_ color: Color, in context: CGContext, bounds: CGRect) {
        context.clear(bounds)
        context.setFillColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        context.fill(bounds)
    }




    /// An RGBA bitmap context. Its origin is at the bottom-left with +y up,
    /// which is what `SceneNode.renderFrame(_:in:)` expects.
    private func makeContext(width: Int, height: Int) throws -> CGContext {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              )
        else {
            throw RenderError.couldNotCreateContext
        }
        return context
    }




    private func writePNG(_ image: CGImage, to url: URL) throws {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil) else {
            throw RenderError.couldNotWritePNG(url)
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw RenderError.couldNotWritePNG(url)
        }
    }




    private func padded(_ frame: Integer, to digits: Int) -> String {
        let number = String(abs(frame))
        let zeros = String(repeating: "0", count: max(0, digits - number.count))
        return (frame < 0 ? "-" : "") + zeros + number
    }
}

