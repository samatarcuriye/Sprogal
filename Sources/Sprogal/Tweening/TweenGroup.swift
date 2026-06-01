import Foundation





// MARK: - Declaration

/// A group of playable items with configurable overlap between them.
///
/// The `overlap` property controls timing:
/// - `0` — sequential: each item starts after the previous ends.
/// - `1` — parallel: all items start at the same time.
/// - `0.5` — staggered: each item starts halfway through the previous.
///
/// Groups can be nested — a `TweenGroup` conforms to `Playable`,
/// so it can be added to another group or directly to a timeline.
///
/// ```swift
/// let group = TweenGroup(overlap: 0.5)
///     .add(node.tween.setPosition(to: Point(x: 2, y: 0), duration: 2))
///     .add(node.tween.setOpacity(to: 0, duration: 2))
///
/// self.timeline.append(group)
/// ```
public class TweenGroup {
    
    
    
    
    
    /// The overlap between consecutive items, from `0`
    /// (sequential) to `1` (parallel).
    public let overlap: Scalar
    
    
    
    
    
    /// The entries in this group, in the order they were added.
    private var entries: [Entry] = []
    
    
    
    
    
    /// A single entry in the group.
    private enum Entry {
        
        
        
        
        
        /// A playable item.
        case playable(Playable)
        
        
        
        
        
        /// A tween builder whose tweens are treated as a single parallel entry.
        case builder(TweenBuilder)
        
        
        
        
        
    }
    
    
    
    
    
    /// Creates a tween group with the given overlap.
    ///
    /// The overlap must be in the range `0` to `1`.
    /// A precondition failure occurs if the value falls outside that range.
    /// - Parameter overlap: The overlap between consecutive
    ///   items. Defaults to `1` (parallel).
    public init(overlap: Scalar = 1) {
        precondition(overlap >= 0 && overlap <= 1, "Overlap must be between 0 and 1.")
        self.overlap = overlap
    }
    
    
    
    
    
}





// MARK: - Playable

/// Confirms that `TweenGroup` can be scheduled on a timeline.
extension TweenGroup: Playable {
    
    
    
    
    
    /// The total duration of the group, computed from the
    /// overlap and the durations of all entries.
    public var duration: Scalar {
        return self.computeDuration()
    }
    
    
    
    
    
    /// A closure that applies all entries at their computed
    /// start times, offset by the given base start time.
    public var apply: (_ startTime: Scalar) -> Void {
        return { startTime in
            self.applyEntries(at: startTime)
        }
    }
    
    
    
    
    
}





// MARK: - Adding Entries

/// Methods for adding playable items and builders to the group.
extension TweenGroup {
    
    
    
    
    
    /// Adds a playable item to the group.
    ///
    /// Accepts any `Playable` — a `Tween`, a `Hold`, a nested
    /// `TweenGroup`, or any other conforming type.
    ///
    /// A precondition failure occurs if a `Hold` is added to a
    /// group with overlap `1.0`, or if a tween would animate
    /// the same property on the same node as an existing entry
    /// in a group with overlap `1.0`.
    /// - Parameter playable: The item to add.
    /// - Returns: This group, for chaining.
    @discardableResult
    public func add(_ playable: Playable) -> TweenGroup {
        self.validateHold(playable)
        self.validateTweenConflict(playable)
        self.entries.append(.playable(playable))
        return self
    }
    
    
    
    
    
    /// Adds all tweens from a builder to the group.
    ///
    /// The builder's tweens are treated as a single parallel
    /// entry — they all start at the same time within the
    /// group, and the entry's duration is the longest tween.
    ///
    /// A precondition failure occurs if any tween in the builder
    /// would animate the same property on the same node as an
    /// existing entry in a group with overlap `1.0`.
    /// - Parameter builder: The tween builder whose tweens
    ///   to add.
    /// - Returns: This group, for chaining.
    @discardableResult
    public func add(_ builder: TweenBuilder) -> TweenGroup {
        self.validateBuilderConflict(builder)
        self.entries.append(.builder(builder))
        return self
    }
    
    
    
    
    
}





// MARK: - Conflict Detection

/// Private methods for detecting conflicting entries.
extension TweenGroup {
    
    
    
    
    
    /// Validates that a `Hold` is not being added to a group
    /// with overlap `1.0`.
    /// - Parameter playable: The playable to check.
    private func validateHold(_ playable: Playable) {
        guard playable is Hold else { return }
        precondition(
            self.overlap < 1,
            "Cannot add Hold to a TweenGroup with overlap \(self.overlap)."
        )
    }
    
    
    
    
    
    /// Validates that a tween does not conflict with existing
    /// entries when overlap is greater than `0`.
    /// - Parameter playable: The playable to check.
    private func validateTweenConflict(_ playable: Playable) {
        guard self.overlap > 0 else { return }
        guard let tween = playable as? Tween else { return }
        guard let identity = tween.identity,
              let property = tween.property else { return }
        
        let existingProperties = self.collectAnimatedProperties()
        
        precondition(
            !existingProperties.contains(where: { $0.node == identity && $0.property == property }),
            "Cannot animate \(property) twice in the same TweenGroup when overlap is \(self.overlap)."
        )
    }
    
    
    
    
    
    /// Validates that no tween in a builder conflicts with
    /// existing entries when overlap is greater than `0`.
    /// - Parameter builder: The builder to check.
    private func validateBuilderConflict(_ builder: TweenBuilder) {
        guard self.overlap > 0 else { return }
        
        let existingProperties = self.collectAnimatedProperties()
        
        for tween in builder.tweens {
            guard let identity = tween.identity,
                  let property = tween.property else { continue }
            
            precondition(
                !existingProperties.contains(where: { $0.node == identity && $0.property == property }),
                "Cannot animate \(property) twice in the same TweenGroup when overlap is \(self.overlap)."
            )
        }
    }
    
    
    
    
    
    /// Collects all node + property pairs from existing entries.
    /// - Returns: An array of animated property identifiers.
    private func collectAnimatedProperties() -> [(node: ObjectIdentifier, property: String)] {
        var properties: [(node: ObjectIdentifier, property: String)] = []
        
        for entry in self.entries {
            switch entry {
            case .playable(let playable):
                if let tween = playable as? Tween,
                   let identity = tween.identity,
                   let property = tween.property {
                    properties.append((node: identity, property: property))
                }
            case .builder(let builder):
                for tween in builder.tweens {
                    if let identity = tween.identity,
                       let property = tween.property {
                        properties.append((node: identity, property: property))
                    }
                }
            }
        }
        
        return properties
    }
    
    
    
    
    
}





// MARK: - Applying

/// Private methods for applying entries at their computed start times.
extension TweenGroup {
    
    
    
    
    
    /// Applies all entries at their computed start times,
    /// offset by the given base start time.
    /// - Parameter startTime: The base start time for this
    ///   group.
    private func applyEntries(at startTime: Scalar) {
        let offsets = self.computeStartOffsets()
        
        for index in 0..<self.entries.count {
            let entryStartTime = startTime + offsets[index]
            self.applyEntry(at: index, startTime: entryStartTime)
        }
    }
    
    
    
    
    
    /// Applies a single entry at the given start time.
    /// - Parameters:
    ///   - index: The entry index.
    ///   - startTime: The start time for this entry.
    private func applyEntry(at index: Int, startTime: Scalar) {
        let entry = self.entries[index]
        
        switch entry {
        case .playable(let playable):
            playable.apply(startTime)
        case .builder(let builder):
            for tween in builder.tweens {
                tween.apply(startTime)
            }
        }
    }
    
    
    
    
    
}





// MARK: - Timing

/// Private methods for computing entry start offsets and total duration.
extension TweenGroup {
    
    
    
    
    
    /// Computes the start offset for each entry based on the
    /// overlap value.
    /// - Returns: An array of start offsets, one per entry.
    private func computeStartOffsets() -> [Scalar] {
        guard !self.entries.isEmpty else {
            return []
        }
        
        var offsets: [Scalar] = []
        offsets.reserveCapacity(self.entries.count)
        var cursor: Scalar = 0
        
        for index in 0..<self.entries.count {
            offsets.append(cursor)
            
            if index < self.entries.count - 1 {
                let entryDuration = self.computeEntryDuration(at: index)
                let advance = entryDuration * (1 - self.overlap)
                cursor = cursor + advance
            }
        }
        
        return offsets
    }
    
    
    
    
    
    /// Computes the total duration of the group.
    /// - Returns: The total duration.
    private func computeDuration() -> Scalar {
        guard !self.entries.isEmpty else {
            return 0
        }
        
        let offsets = self.computeStartOffsets()
        var maxEndTime: Scalar = 0
        
        for index in 0..<self.entries.count {
            let entryEnd = offsets[index] + self.computeEntryDuration(at: index)
            if entryEnd > maxEndTime {
                maxEndTime = entryEnd
            }
        }
        
        return maxEndTime
    }
    
    
    
    
    
    /// Computes the duration of the entry at the given index.
    /// - Parameter index: The entry index.
    /// - Returns: The entry's duration.
    private func computeEntryDuration(at index: Int) -> Scalar {
        let entry = self.entries[index]
        
        switch entry {
        case .playable(let playable):
            return playable.duration
        case .builder(let builder):
            var longestDuration: Scalar = 0
            for tween in builder.tweens {
                if tween.duration > longestDuration {
                    longestDuration = tween.duration
                }
            }
            return longestDuration
        }
    }
    
    
    
    
    
}

