import SwiftUI

struct ContentView: View {
    @StateObject var game = PokerGame()

    var body: some View {
        VStack(spacing: 16) {
            Text("Texas Hold’em").font(.largeTitle)

            Text("Opponent's Hand")
            CardRowView(cards: game.opponent.hand, faceUp: false)

            Text("Community Cards")
            CardRowView(cards: game.communityCards)

            Text("Your Hand")
            CardRowView(cards: game.player.hand)

            HStack {
                Button("New Game", action: game.startNewGame)
                Button("Flop", action: game.dealFlop)
                Button("Turn", action: game.dealTurn)
                Button("River", action: game.dealRiver)
            }.buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct CardRowView: View {
    let cards: [Card]
    var faceUp: Bool = true

    var body: some View {
        HStack {
            ForEach(cards) { card in
                Text(faceUp ? card.description : "🂠")
                    .font(.system(size: 30))
                    .frame(width: 40, height: 60)
                    .background(Color.white)
                    .cornerRadius(6)
                    .shadow(radius: 2)
            }
        }
    }
}
