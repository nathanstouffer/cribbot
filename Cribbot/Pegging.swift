struct Pegging {

  struct Stack {

    struct Lay {
      let card: Card
      let by: Game.Player
    }

    var lays = [Lay]()

    var last: Lay? {
      lays.last
    }

    var cards: [Card] {
      lays.map { $0.card }
    }

    func sum() -> Int {
      cards.sum()
    }

    func allows(card: Card) -> Bool {
      sum() + card.peggingValue <= 31
    }

    mutating func push(card: Card, by: Game.Player) {
      lays.append(Lay(card: card, by: by))
    }

  }

  var turn: Game.Player
  var stack = Stack()
  var adaGo = false
  var bobGo = false

  var someGo: Bool {
    adaGo || bobGo
  }

  var noGo: Bool {
    !someGo
  }

  var bothGo: Bool {
    return adaGo && bobGo
  }

  func allows(card: Card) -> Bool {
    stack.allows(card: card)
  }
}
