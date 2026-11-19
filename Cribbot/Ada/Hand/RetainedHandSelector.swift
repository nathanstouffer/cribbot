/// A hand selector that chooses the cards to keep based solely on
/// how the good the retained hand scores
struct RetainedHandSelector: HandSelector {
  
  func keep(cards: [Card]) -> [Card] {
    return [Card]()
  }
  
}
