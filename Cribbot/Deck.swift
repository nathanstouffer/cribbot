import Foundation

/// A simple deck model that owns an ordered array of `Card` values
struct Deck {
  private(set) var cards: [Card]

  /// Create a new deck in standard order or optionally shuffled
  init(shuffled: Bool = false) {
    self.cards = Card.fullDeckByRank
    if shuffled { self.shuffle() }
  }

  /// Shuffle the deck in-place
  mutating func shuffle() {
    cards.shuffle()
  }

  /// Deal `count` cards from the top of the deck.
  /// - Returns: An array of dealt cards, or `nil` if there aren't enough cards.
  @discardableResult
  mutating func deal(_ count: Int) -> [Card]? {
    guard count >= 0, count <= cards.count else { return nil }
    let hand = Array(cards.prefix(count))
    cards.removeFirst(count)
    return hand
  }

  /// Peek at the top `count` cards without removing them.
  func peek(_ count: Int) -> [Card]? {
    guard count >= 0, count <= cards.count else { return nil }
    return Array(cards.prefix(count))
  }

  /// Number of cards remaining in the deck
  var count: Int { cards.count }
}

// MARK: - Examples for quick manual testing in previews or playgrounds
extension Deck {
  static func exampleDeal() -> ([Card], Deck) {
    var deck = Deck(shuffled: true)
    let hand = deck.deal(6) ?? []
    return (hand, deck)
  }
}
