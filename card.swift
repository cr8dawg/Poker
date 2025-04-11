enum Suit: String, CaseIterable {
    case hearts = "♥️", diamonds = "♦️", clubs = "♣️", spades = "♠️"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var symbol: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return String(self.rawValue)
        }
    }
}

struct Card: Identifiable, CustomStringConvertible {
    let id = UUID()
    let suit: Suit
    let rank: Rank

    var description: String {
        return "\(rank.symbol)\(suit.rawValue)"
    }
}
