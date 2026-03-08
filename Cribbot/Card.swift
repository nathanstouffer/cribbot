import Foundation
import SwiftUI  // only imported to easily assign color to the suit

struct Card: Hashable, Identifiable {

  enum Rank {
    case ace, two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    var display: String {
      switch self {
      case .ace: return "A"
      case .two: return "2"
      case .three: return "3"
      case .four: return "4"
      case .five: return "5"
      case .six: return "6"
      case .seven: return "7"
      case .eight: return "8"
      case .nine: return "9"
      case .ten: return "10"
      case .jack: return "J"
      case .queen: return "Q"
      case .king: return "K"
      }
    }
  }

  enum Suit {
    case spades
    case hearts
    case clubs
    case diamonds

    var symbol: String {
      switch self {
      case .hearts: return "❤️"
      case .spades: return "♠️"
      case .diamonds: return "♦️"
      case .clubs: return "♣️"
      }
    }

    var color: Color {
      switch self {
      case .hearts, .diamonds: return .red
      case .spades, .clubs: return .black
      }
    }
  }

  let rank: Rank
  let suit: Suit

  var id: String {
    "\(rank)-\(suit)"
  }
}

// MARK: - Preview helpers

extension Card.Rank {
  static let all: [Self] = [
    .ace, .two, .three, .four, .five, .six,
    .seven, .eight, .nine, .ten,
    .jack, .queen, .king,
  ]
}

extension Card.Suit {
  static let all: [Self] = [
    .hearts, .spades, .diamonds, .clubs,
  ]
}

extension Card {
  static let preview = Card(rank: .king, suit: .hearts)

  static let fullDeckBySuit: [Card] = {
    return Card.Suit.all.flatMap { suit in
      Card.Rank.all.map { rank in
        Card(rank: rank, suit: suit)
      }
    }
  }()

  static let fullDeckByRank: [Card] = {
    return Card.Rank.all.flatMap { rank in
      Card.Suit.all.map { suit in
        Card(rank: rank, suit: suit)
      }
    }
  }()
}
