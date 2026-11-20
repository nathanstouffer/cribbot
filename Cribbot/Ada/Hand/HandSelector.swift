protocol HandSelector {

  func keep(cards: [Card], ownsCrib: Bool) -> [Card]
  func toss(cards: [Card], ownsCrib: Bool) -> [Card]

}

struct TossCandidate {
  let toss: [Card]
  let score: Double
  let sum: Int
}

extension HandSelector {

  /// Default implementation for keep -- written in terms of toss
  func keep(cards: [Card], ownsCrib: Bool) -> [Card] {
    cards.minus(toss(cards: cards, ownsCrib: ownsCrib))
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

}

extension [Card] {

  /// Return a copy  of self with all passed in elements removed
  func minus(_ rhs: [Card]) -> [Card] {
    filter { !rhs.contains($0) }
  }
  
  func minus(_ rhs: Card) -> [Card] {
    minus([rhs])
  }

}
