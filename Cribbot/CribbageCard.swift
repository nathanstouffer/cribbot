struct CribbageCard {

  enum Owner {
    case deck
    case player1
    case player2
    case crib
    case flip
  }

  let card: Card
  let owner: Owner

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
