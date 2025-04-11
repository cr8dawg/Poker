struct Deck {
    private(set) var cards: [Card] = []

    init() {
        reset()
    }

    mutating func reset() {
        cards = Suit.allCases.flatMap { suit in
            Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }.shuffled()
    }

    mutating func deal(_ count: Int) -> [Card] {
        return Array(cards.prefix(count)).onDelete {
            cards.removeFirst(count)
        }
    }
}

extension Array {
    func onDelete(_ perform: () -> Void) -> [Element] {
        perform()
        return self
    }
}
