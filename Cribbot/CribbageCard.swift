struct CribbageCard {

  enum Owner {
    case deck
    case ada
    case bob
    case crib
    case flip

    var isPlayer: Bool {
      return self == .ada || self == .bob
    }
  }

  let card: Card
  var owner: Owner

  init(_ card: Card) {
    self.card = card
    self.owner = .deck
  }

  var id: String {
    card.id
  }

  var debugDescription: String {
    return id
  }
}

extension CribbageCard {
  static let fullDeckByRank: [CribbageCard] = {
    return Card.Rank.all.flatMap { rank in
      Card.Suit.all.map { suit in
        CribbageCard(Card(rank, suit))
      }
    }
  }()
}
