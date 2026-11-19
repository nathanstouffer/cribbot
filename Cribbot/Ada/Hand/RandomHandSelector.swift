struct RandomHandSelector: HandSelector {
  
  func keep(cards: [Card]) -> [Card] {
    Array(cards.shuffled().prefix(2))
  }
  
}
