import Foundation

enum HandStaging {

  static let preThrowCap = 2

  case preThrow(Set<Card>)
  case pegging(Card?)

  func contains(_ card: Card) -> Bool {
    switch self {
    case .preThrow(let set): return set.contains(card)
    case .pegging(let staged): return staged == card
    }
  }

  mutating func toggle(_ card: Card) {
    switch self {
    case .preThrow(var set):
      if set.contains(card) {
        set.remove(card)
      } else if set.count < Self.preThrowCap {
        set.insert(card)
      }
      self = .preThrow(set)
    case .pegging:
      break
    }
  }
}
