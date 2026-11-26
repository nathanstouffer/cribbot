protocol PegSelector {

  func lay(played: [Card], available: [Card]) -> Card?

}

struct LayCandidate {
  let lay: Card
  let score: Double
}

extension PegSelector {

  /// Compute the cards which are valid to play
  func valid(played: [Card], available: [Card]) -> [Card] {
    available.filter { played.sum() + $0.peggingValue <= 31 }
  }

}
