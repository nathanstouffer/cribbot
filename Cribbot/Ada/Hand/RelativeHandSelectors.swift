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
    let flipOptions = Card.fullDeckByRank.minus(hand).minus(toss)
    let flipProbability = 1.0 / Double(flipOptions.count)
    for flipped in flipOptions {
      let handScore = score(hand: hand, flip: flipped, isCrib: false)
      let oppoTossOptions = approximateTossOptions(flipOptions.minus(flipped))
      let oppoTossProbability = 1.0 / Double(oppoTossOptions.count)
      let probability = flipProbability * oppoTossProbability
      for oppoToss in oppoTossOptions {
        let cribScore = score(hand: toss + oppoToss, flip: flipped, isCrib: true)
        let score = ownsCrib ? handScore + cribScore : handScore - cribScore
        expected += probability * Double(score)
      }
    }
    return TossCandidate(toss: toss, score: expected, sum: hand.sum())
  }
  
  private func approximateTossOptions(_ available: [Card]) -> [[Card]] {
    var compacted = [Card]()
    var c = 0
    for card in available {
      if compacted.count == 0 || compacted.count == 1 {
        compacted.append(card)
        c += 1
      } else {
        let prev = compacted[c - 1]
        let ante = compacted[c - 2]
        if card.rank != prev.rank {
          compacted.append(card)
          c += 1
        } else if card.rank != ante.rank {
          compacted.append(card)
          c += 1
        }
      }
    }
    return compacted.allPairs()
  }

}
