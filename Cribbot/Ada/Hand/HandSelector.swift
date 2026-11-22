nonisolated protocol HandSelector {

  func keep(cards: [Card], ownsCrib: Bool) async -> [Card]
  func toss(cards: [Card], ownsCrib: Bool) async -> [Card]

}

struct TossCandidate {
  let toss: [Card]
  let score: Double
  let sum: Int
}

extension HandSelector {

  /// Default implementation for keep -- written in terms of toss
  func keep(cards: [Card], ownsCrib: Bool) async -> [Card] {
    await cards.minus(toss(cards: cards, ownsCrib: ownsCrib))
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

  /// Return all pairs of Cards in the array. This is all pairs of elements in the array,
  /// not a scoring pair
  func allPairs() -> [[Card]] {
    let nChoose2 = count * (count - 1) / 2
    let capacity = count >= 2 ? nChoose2 : 0
    var variants = [[Card]]()
    variants.reserveCapacity(capacity)
    for i in 0..<count - 1 {
      for j in i + 1..<count {
        variants.append([self[i], self[j]])
      }
    }
    return variants
  }

  /// Return all triples of Cards in the array. This is all triples of elements in the array,
  /// not a scoring triple
  func allTriples() -> [[Card]] {
    let nChoose3 = count * (count - 1) * (count - 2) / 6
    let capacity = count >= 3 ? nChoose3 : 0
    var variants = [[Card]]()
    variants.reserveCapacity(capacity)
    for i in 0..<count - 2 {
      for j in i + 1..<count - 1 {
        for k in j + 1..<count {
          variants.append([self[i], self[j], self[k]])
        }
      }
    }
    return variants
  }

}
