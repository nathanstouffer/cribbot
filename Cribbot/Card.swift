import Foundation
import SwiftUI  // only imported to easily assign color to the suit

struct Card: Hashable, Identifiable, CustomDebugStringConvertible {

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

    var peggingValue: Int {
      switch self {
      case .ace: return 1
      case .two: return 2
      case .three: return 3
      case .four: return 4
      case .five: return 5
      case .six: return 6
      case .seven: return 7
      case .eight: return 8
      case .nine: return 9
      case .ten: return 10
      case .jack: return 10
      case .queen: return 10
      case .king: return 10
      }
    }

    var runValue: Int {
      switch self {
      case .ace: return 1
      case .two: return 2
      case .three: return 3
      case .four: return 4
      case .five: return 5
      case .six: return 6
      case .seven: return 7
      case .eight: return 8
      case .nine: return 9
      case .ten: return 10
      case .jack: return 11
      case .queen: return 12
      case .king: return 13
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

  init(_ rank: Rank, _ suit: Suit) {
    self.rank = rank
    self.suit = suit
  }

  var id: String {
    "\(rank) of \(suit)"
  }

  var debugDescription: String {
    return id
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
  static let preview = Card(.king, .hearts)

  static let fullDeckBySuit: [Card] = {
    return Card.Suit.all.flatMap { suit in
      Card.Rank.all.map { rank in
        Card(rank, suit)
      }
    }
  }()

  static let fullDeckByRank: [Card] = {
    return Card.Rank.all.flatMap { rank in
      Card.Suit.all.map { suit in
        Card(rank, suit)
      }
    }
  }()
}
