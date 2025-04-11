let allCards = player.hand + communityCards
let (rank, highCards) = HandEvaluator.evaluateHand(allCards)
print("Best hand: \(rank) with top cards: \(highCards.map { "\($0)" }.joined(separator: ", "))")
