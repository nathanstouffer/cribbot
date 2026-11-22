/// A hand selector that chooses the cards to keep based solely on
/// how the good the retained hand scores
struct RetainedHandSelector: HandSelector {

  func toss(cards: [Card], ownsCrib: Bool) -> [Card] {
    var best = TossCandidate(toss: [], score: 0.0, sum: 10000)  // assign invalid value that will be overwritten
    for toss in cards.allPairs() {
      let candidate = evaluate(hand: cards.minus(toss), toss: toss, ownsCrib: ownsCrib)
      if candidate.score > best.score {
        best = candidate
      } else if candidate.score == best.score {
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

  func evaluate(hand: [Card], toss: [Card], ownsCrib _: Bool) -> TossCandidate {
    // compute the expected value of the hand over all possible flipped cards
    var expected = 0.0
    let flipOptions = Card.fullDeckByRank.minus(hand).minus(toss)
    let flipProbability = 1.0 / Double(flipOptions.count)
    for flipped in flipOptions {
      let s = score(hand: hand, flip: flipped, isCrib: false)
      expected += flipProbability * Double(s)
    }
    return TossCandidate(toss: toss, score: expected, sum: hand.sum())
  }

}
