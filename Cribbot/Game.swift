import Foundation

struct Game {

  enum Player: CaseIterable {
    case ada
    case bob

    mutating func toggle() {
      if self == .ada {
        self = .bob
      } else {
        self = .ada
      }
    }
  }

  struct ScoringProgress {
    var nondealerHand = false
    var dealerHand = false
    var crib = false

    var isDone: Bool {
      nondealerHand && dealerHand && crib
    }
  }

  private(set) var adaScore = 0
  private(set) var bobScore = 0

  private(set) var cribOwner = Player.allCases.randomElement()!

  private(set) var cards = CribbageCard.fullDeckByRank

  private(set) var scoringProgress = ScoringProgress()

  var deck: [Card] {
    cards.filter { $0.owner == .deck }.map { $0.card }
  }

  var adaHand: [CribbageCard] {
    cards.filter { $0.owner == .ada }
  }

  var bobHand: [CribbageCard] {
    cards.filter { $0.owner == .bob }
  }

  var adaCards: [Card] {
    adaHand.map { $0.card }
  }

  var bobCards: [Card] {
    bobHand.map { $0.card }
  }

  var crib: [Card] {
    cards.filter { $0.owner == .crib }.map { $0.card }
  }

  var flipped: Card? {
    cards.first(where: { $0.owner == .flip })?.card
  }

  mutating func toggleCrib() {
    cribOwner.toggle()
  }

  mutating func shuffle() {
    cards = CribbageCard.fullDeckByRank
    cards.shuffle()
    scoringProgress = ScoringProgress()
  }

  mutating func deal() {
    precondition(deck.count == 52, "Deck has not been reset")
    for i in 0..<6 {
      cards[2 * i + 0].owner = .ada
      cards[2 * i + 1].owner = .bob
    }
  }

  mutating func flip() {
    precondition(crib.count == 4, "Crib has not been selected")
    let selected = deck.randomElement()!
    let i = findIndex(selected)
    cards[i].owner = .flip
  }

  mutating func toss(_ left: Card, _ right: Card, by: Player) {
    precondition(find(left).owner == by && find(right).owner == by, "Tossing unowned cards to crib")
    precondition(crib.count <= 2, "Crib will exceed max size")
    toss(left)
    toss(right)
  }

  mutating func lay(_ card: Card, by: Player) {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(find(card).owner == by, "Card is not owned by player")
    precondition(!find(card).layed, "Card has already been layed")
    let i = findIndex(card)
    cards[i].layed = true
  }

  mutating func scoreNondealer() {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(
      !scoringProgress.crib && !scoringProgress.dealerHand, "Nondealer must be scored first")
    if cribOwner == .ada {
      bobScore += score(hand: bobCards, flip: flipped!, isCrib: false)
    }
    if cribOwner == .bob {
      adaScore += score(hand: adaCards, flip: flipped!, isCrib: false)
    }
    scoringProgress.nondealerHand = true
  }

  mutating func scoreDealer() {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(scoringProgress.nondealerHand, "Nondealer hand must be scored before dealer")
    if cribOwner == .ada {
      adaScore += score(hand: adaCards, flip: flipped!, isCrib: false)
    }
    if cribOwner == .bob {
      bobScore += score(hand: bobCards, flip: flipped!, isCrib: false)
    }
    scoringProgress.dealerHand = true
  }
  mutating func scoreCrib() {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(scoringProgress.dealerHand, "Dealer hand must be scored before crib")
    if cribOwner == .ada {
      adaScore += score(hand: crib, flip: flipped!, isCrib: true)
    }
    if cribOwner == .bob {
      bobScore += score(hand: crib, flip: flipped!, isCrib: true)
    }
    scoringProgress.crib = true
  }

  // MARK: - Private helpers
  private func find(_ card: Card) -> CribbageCard {
    cards[findIndex(card)]
  }

  private func findIndex(_ card: Card) -> Int {
    guard let i = cards.firstIndex(where: { $0.id == card.id }) else {
      fatalError("Searching for card that does not exist")
    }
    return i
  }

  private mutating func toss(_ card: Card) {
    let i = findIndex(card)
    cards[i].owner = .crib
  }
}

// MARK: - Equality operators

func == (_ lhs: Game.Player, _ rhs: CribbageCard.Owner) -> Bool {
  switch lhs {
  case .ada: return rhs == CribbageCard.Owner.ada
  case .bob: return rhs == CribbageCard.Owner.bob
  }
}

func == (_ lhs: CribbageCard.Owner, _ rhs: Game.Player) -> Bool {
  return rhs == lhs
}

func != (_ lhs: Game.Player, _ rhs: CribbageCard.Owner) -> Bool {
  return !(lhs == rhs)
}

func != (_ lhs: CribbageCard.Owner, _ rhs: Game.Player) -> Bool {
  return !(lhs == rhs)
}
