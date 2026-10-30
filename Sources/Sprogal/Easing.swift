




/// A curve that reshapes progress through a motion.
///
/// Every curve maps 0 to 0 and 1 to 1; what changes is how it gets there.
/// Use it on a keyframe (`Keyframe(frame:value:easing:)`), or inside an
/// expression or modifier with `apply(to:)`,
/// `ease(at:startFrame:endFrame:)` for eased progress, or
/// `ease(at:startFrame:endFrame:startValue:endValue:)` for an eased value.
public enum Easing {





    /// Constant speed.
    case linear





    /// Starts slow and speeds up.
    case easeIn





    /// Starts fast and slows down.
    case easeOut





    /// Starts slow, speeds up, and slows down again.
    case easeInOut





    /// A stronger `easeIn`.
    case easeInCubic





    /// A stronger `easeOut`.
    case easeOutCubic





    /// A stronger `easeInOut`.
    case easeInOutCubic





    /// Your own curve. It should map 0 to 0 and 1 to 1, or the motion will jump
    /// at the start or end of the span it's used on.
    case custom((Scalar) -> Scalar)





    /// Eases `progress`, a fraction from 0 (start) to 1 (end). Values outside
    /// 0...1 are passed through the same formula, unclamped.
    public func apply(to progress: Scalar) -> Scalar {
        switch self {
        case .linear:
            return progress

        case .easeIn:
            return Easing.easeIn(progress, power: Easing.quadratic)

        case .easeOut:
            return Easing.easeOut(progress, power: Easing.quadratic)

        case .easeInOut:
            return Easing.easeInOut(progress, power: Easing.quadratic)

        case .easeInCubic:
            return Easing.easeIn(progress, power: Easing.cubic)

        case .easeOutCubic:
            return Easing.easeOut(progress, power: Easing.cubic)

        case .easeInOutCubic:
            return Easing.easeInOut(progress, power: Easing.cubic)

        case .custom(let curve):
            return curve(progress)
        }
    }




}





// MARK: Curve shapes
extension Easing {





    /// The power for the gentle curves: progress squared.
    private static let quadratic = 2





    /// The power for the strong curves: progress cubed.
    private static let cubic = 3





    /// The point where an in-out curve switches from easing in to easing out.
    private static let halfway: Scalar = 0.5





    /// Slow start: progress raised to `power`. A higher power waits longer
    /// before speeding up.
    private static func easeIn(_ progress: Scalar, power: Int) -> Scalar {
        var result: Scalar = 1
        for _ in 0..<power {
            result *= progress
        }
        return result
    }





    /// Slow finish: `easeIn` played backwards. It eases in on the progress that's
    /// left, then flips the result so it still runs from 0 to 1.
    private static func easeOut(_ progress: Scalar, power: Int) -> Scalar {
        let remaining = 1 - progress
        return 1 - Easing.easeIn(remaining, power: power)
    }





    /// Slow start and slow finish: `easeIn` over the first half of the time,
    /// covering the first half of the distance, then `easeOut` over the second
    /// half of the time, covering the rest.
    private static func easeInOut(_ progress: Scalar, power: Int) -> Scalar {
        if progress < Easing.halfway {
            let progressThroughFirstHalf = progress / Easing.halfway
            return Easing.easeIn(progressThroughFirstHalf, power: power) * Easing.halfway
        }

        let remaining = 1 - progress
        let remainingThroughSecondHalf = remaining / Easing.halfway
        return 1 - Easing.easeIn(remainingThroughSecondHalf, power: power) * Easing.halfway
    }





}

