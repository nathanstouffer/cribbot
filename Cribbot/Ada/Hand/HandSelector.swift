protocol HandSelector {

  func keep(cards: [Card]) -> [Card]
  func toss(cards: [Card]) -> [Card]
}

extension HandSelector {

  /// Default implementation for toss -- written in terms of keep
  func toss(cards: [Card]) -> [Card] {
    cards.minus(keep(cards: cards))
  }

  func allPossibleTosses(cards: [Card]) -> [[Card]] {
    var variants = [[Card]]()
    for i in 0..<cards.count - 1 {
      for j in i + 1..<cards.count {
        variants.append([cards[i], cards[j]])
      }
    }
    return variants
  }

  /// Compute the expected value of the hand over all possible flipped cards
  func expectedValue(cards: [Card], dead: [Card], isCrib: Bool) -> Double {
    var expected = 0.0
    let options = Card.fullDeckByRank.minus(cards).minus(dead)
    let flipProbability = 1.0 / Double(options.count)
    for flipped in options {
      let s = score(hand: cards, flip: flipped, isCrib: isCrib)
      expected += flipProbability * Double(s)
    }
    return expected
  }

}

extension [Card] {

  /// Return a copy with all passed in elements removed
  func minus(_ rhs: [Card]) -> [Card] {
    filter { !rhs.contains($0) }
  }
}
