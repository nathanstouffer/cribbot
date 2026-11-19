/// A hand selector that chooses the cards to keep based solely on
/// how the good the retained hand scores
struct RetainedHandSelector: HandSelector {

  struct Candidate {
    let toss: [Card]
    let score: Double
    let sum: Int
  }

  func keep(cards: [Card]) -> [Card] {
    var best = Candidate(toss: [], score: 0.0, sum: 10000)  // assign invalid value that will be overwritten
    for toss in allPossibleTosses(cards: cards) {
      let hand = cards.minus(toss)
      let score = expectedValue(cards: hand, dead: toss, isCrib: false)
      let candidate = Candidate(toss: toss, score: score, sum: hand.sum())
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
    return cards.minus(best.toss)
  }

}
