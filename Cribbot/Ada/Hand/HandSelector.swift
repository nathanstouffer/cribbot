protocol HandSelector {
  func keep(cards: [Card]) -> [Card]
  func toss(cards: [Card]) -> [Card]
}

extension HandSelector {
  func toss(cards: [Card]) -> [Card] {
    let kept = keep(cards: cards)
    return cards.filter { kept.contains($0) }
  }
}
