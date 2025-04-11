class PokerGame: ObservableObject {
    @Published var deck = Deck()
    @Published var player = Player(name: "You")
    @Published var opponent = Player(name: "AI")
    @Published var communityCards: [Card] = []

    func startNewGame() {
        deck.reset()
        player.hand = deck.deal(2)
        opponent.hand = deck.deal(2)
        communityCards = []
    }

    func dealFlop() {
        communityCards += deck.deal(3)
    }

    func dealTurn() {
        communityCards += deck.deal(1)
    }

    func dealRiver() {
        communityCards += deck.deal(1)
    }

    func allCards(for player: Player) -> [Card] {
        return player.hand + communityCards
    }

    // Add hand evaluation here later
}
