/// A hand selector that chooses the cards to keep based solely on
/// how the good the retained hand scores
struct RetainedHandSelector: HandSelector {

  func toss(cards: [Card]) -> [Card] {
    var best = CandidateToss(toss: [], score: 0.0, sum: 10000)  // assign invalid value that will be overwritten
    for toss in allPossibleTosses(cards: cards) {
      let hand = cards.minus(toss)
      let score = expectedValue(cards: hand, dead: toss, isCrib: false)
      let candidate = CandidateToss(toss: toss, score: score, sum: hand.sum())
      if score > best.score {
        best = candidate
      } else if score == best.score {
        if candidate.sum < best.sum {
          best = candidate
        }
      }
    }
    guard !best.toss.isEmpty else {
      fatalError("RetainedHandSelector failed to compute a best toss")
    }
    return best.toss
  }

}
