protocol PegSelector {

  func lay(played: [Card], available: [Card]) -> Card?

}

struct LayCandidate {
  let lay: Card
  let score: Double
}
