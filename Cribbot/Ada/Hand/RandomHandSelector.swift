/// A hand selector that chooses the cards to keep randomly
struct RandomHandSelector: HandSelector {

  func toss(cards: [Card]) -> [Card] {
    Array(cards.shuffled().prefix(2))
  }

}
