import Foundation

struct HandEvaluator {
    static func evaluateHand(_ cards: [Card]) -> (HandRank, [Rank]) {
        let sorted = cards.sorted { $0.rank.rawValue > $1.rank.rawValue }
        let rankGroups = Dictionary(grouping: sorted, by: { $0.rank })
        let suitGroups = Dictionary(grouping: sorted, by: { $0.suit })

        let isFlush = suitGroups.values.contains { $0.count >= 5 }
        let flushCards = suitGroups.first(where: { $0.value.count >= 5 })?.value ?? []

        let straightRanks = detectStraightRanks(in: sorted.map { $0.rank })
        let isStraight = straightRanks.count >= 5

        // Royal Flush
        if isFlush && isStraight && straightRanks.prefix(5).contains(.ace) {
            return (.royalFlush, [.ace])
        }

        // Straight Flush
        if isFlush {
            let flushRanks = flushCards.map { $0.rank }
            let flushStraight = detectStraightRanks(in: flushRanks)
            if flushStraight.count >= 5 {
                return (.straightFlush, Array(flushStraight.prefix(5)))
            }
        }

        // Four of a Kind
        if let four = rankGroups.first(where: { $0.value.count == 4 }) {
            return (.fourOfAKind, [four.key])
        }

        // Full House
        let threes = rankGroups.filter { $0.value.count == 3 }.sorted(by: { $0.key > $1.key })
        let pairs = rankGroups.filter { $0.value.count == 2 }.sorted(by: { $0.key > $1.key })

        if let three = threes.first {
            if let pair = pairs.first {
                return (.fullHouse, [three.key, pair.key])
            } else if threes.count > 1 {
                return (.fullHouse, [threes[0].key, threes[1].key])
            }
        }

        // Flush
        if isFlush {
            return (.flush, Array(flushCards.prefix(5).map { $0.rank }))
        }

        // Straight
        if isStraight {
            return (.straight, Array(straightRanks.prefix(5)))
        }

        // Three of a Kind
        if let three = threes.first {
            return (.threeOfAKind, [three.key])
        }

        // Two Pair
        if pairs.count >= 2 {
            return (.twoPair, [pairs[0].key, pairs[1].key])
        }

        // One Pair
        if let pair = pairs.first {
            return (.onePair, [pair.key])
        }

        // High Card
        return (.highCard, Array(sorted.prefix(5).map { $0.rank }))
    }

    private static func detectStraightRanks(in ranks: [Rank]) -> [Rank] {
        let uniqueRanks = Array(Set(ranks)).sorted(by: { $0.rawValue > $1.rawValue })

        var straight: [Rank] = []
        for i in 0..<uniqueRanks.count {
            if i > 0 && uniqueRanks[i].rawValue == uniqueRanks[i - 1].rawValue - 1 {
                straight.append(uniqueRanks[i])
            } else {
                if straight.count >= 5 { break }
                straight = [uniqueRanks[i]]
            }

            if straight.count >= 5 {
                return straight
            }
        }

        // Special case: A-2-3-4-5 straight
        let lowStraight: [Rank] = [.ace, .two, .three, .four, .five]
        if Set(lowStraight).isSubset(of: Set(ranks)) {
            return lowStraight.reversed()
        }

        return straight
    }
}
