import SwiftUI

struct Game: Identifiable {
    let id = UUID()
    let team1: String
    let team2: String
    let oddsTeam1: Double
    let oddsTeam2: Double
}

struct Bet: Identifiable {
    let id = UUID()
    let game: Game
    let selectedTeam: String
    let amount: Double
}

class BettingViewModel: ObservableObject {
    @Published var balance: Double = 100.0
    @Published var bets: [Bet] = []

    func placeBet(on game: Game, team: String, amount: Double) {
        guard amount > 0, amount <= balance else { return }
        let newBet = Bet(game: game, selectedTeam: team, amount: amount)
        bets.append(newBet)
        balance -= amount
    }
}

struct ContentView: View {
    @StateObject private var viewModel = BettingViewModel()
    @State private var selectedGame: Game?
    @State private var betAmount: String = ""
    @State private var selectedTeam: String?

    let games = [
        Game(team1: "Lions", team2: "Tigers", oddsTeam1: 1.8, oddsTeam2: 2.1),
        Game(team1: "Eagles", team2: "Bears", oddsTeam1: 1.9, oddsTeam2: 2.0)
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Balance: $\(viewModel.balance, specifier: "%.2f")")
                    .font(.headline)

                List(games) { game in
                    VStack(alignment: .leading) {
                        Text("\(game.team1) vs \(game.team2)")
                        HStack {
                            Button("\(game.team1) (\(game.oddsTeam1))") {
                                selectedGame = game
                                selectedTeam = game.team1
                            }
                            Button("\(game.team2) (\(game.oddsTeam2))") {
                                selectedGame = game
                                selectedTeam = game.team2
                            }
                        }
                    }
                }

                if let game = selectedGame, let team = selectedTeam {
                    VStack {
                        Text("Placing bet on: \(team)")
                        TextField("Enter amount", text: $betAmount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button("Place Bet") {
                            if let amount = Double(betAmount) {
                                viewModel.placeBet(on: game, team: team, amount: amount)
                                betAmount = ""
                                selectedGame = nil
                                selectedTeam = nil
                            }
                        }
                        .padding()
                    }
                }

                List(viewModel.bets) { bet in
                    VStack(alignment: .leading) {
                        Text("Bet: \(bet.selectedTeam) vs \(bet.game.team1 == bet.selectedTeam ? bet.game.team2 : bet.game.team1)")
                        Text("Amount: $\(bet.amount, specifier: "%.2f")")
                    }
                }

                Spacer()
            }
            .navigationTitle("Swift Bet")
        }
    }
}
