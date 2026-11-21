/// A hand selector that chooses the cards to keep based on the relative score
/// score of the hand and the crib (opponent's crib counts against)
struct RelativeHandSelector: HandSelector {

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
      fatalError("RelativeHandSelector failed to compute a best toss")
    }
    return best.toss
  }

  func evaluate(hand: [Card], toss: [Card], ownsCrib: Bool) -> TossCandidate {
    // compute the expected value of the hand over all possible flipped cards
    var expected = 0.0
    let remaining = Card.fullDeckByRank.minus(hand).minus(toss)
    let options = remaining.allTriples()
    let tripleProbability = 1.0 / Double(options.count)
    for triple in options {
      let flipProbability = 1.0 / 3.0
      for flipped in triple {
        let handScore = score(hand: hand, flip: flipped, isCrib: false)
        let cribScore = score(hand: toss + triple.minus(flipped), flip: flipped, isCrib: true)
        let score = ownsCrib ? handScore + cribScore : handScore - cribScore
        expected += tripleProbability * flipProbability * Double(score)
      }
    }
    return TossCandidate(toss: toss, score: expected, sum: hand.sum())
  }

}
