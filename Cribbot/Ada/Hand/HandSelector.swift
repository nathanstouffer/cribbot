protocol HandSelector {
  func keep(cards: [Card]) -> [Card]
  func toss(cards: [Card]) -> [Card]
}

extension HandSelector {
  
  /// The probabilty a particular card is flipped
  static var flipProbability: Double {
    1.0 / 46.0
  }
  /// Default implementation for toss -- written in terms of keep
  func toss(cards: [Card]) -> [Card] {
    let kept = keep(cards: cards)
    return cards.filter { kept.contains($0) }
  }
  
  func allPossibleTosses(cards: [Card]) -> [[Card]] {
    var variants = [[Card]]()
    for i in 0..<cards.count-1 {
      for j in i+1..<cards.count {
        variants.append([cards[i], cards[j]])
      }
    }
    return variants
  }
}
