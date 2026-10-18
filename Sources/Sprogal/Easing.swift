




public enum Easing {
    
    
    
    
    
    case linear
    
    
    
    
    
    case easeIn
    
    
    
    
    
    case easeOut
    
    
    
    
    
    case easeInOut
    
    
    
    
    
    func apply(_ fraction: Double) -> Double {
        let progress = min(max(fraction, 0), 1)

        switch self {
        case .linear:
            return progress

        case .easeIn:
            return progress * progress

        case .easeOut:
            let remaining = 1 - progress
            return 1 - remaining * remaining

        case .easeInOut:
            if progress < 0.5 {
                return 2 * progress * progress
            }
            let remaining = 1 - progress
            return 1 - 2 * remaining * remaining
        }
    }
}
