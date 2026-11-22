import Foundation

struct Game {

  enum Player: CaseIterable {
    case ada
    case bob

    func opponent() -> Player {
      if self == .ada {
        return .bob
      } else {
        return .ada
      }
    }

    mutating func toggle() {
      self = opponent()
    }
  }

  struct ScoringProgress {
    var pegging = false
    var nondealerHand = false
    var dealerHand = false
    var crib = false

    var onCrib: Bool {
      pegging && nondealerHand && dealerHand && !crib
    }

    var isDone: Bool {
      pegging && nondealerHand && dealerHand && crib
    }
  }

  struct Pegging {
    var turn: Player
    var stack = [Card]()
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
  }

  private(set) var adaScore = 0
  private(set) var bobScore = 0

  private(set) var cribOwner = Player.allCases.randomElement()!
  private(set) var pegging: Pegging

  private(set) var cards = CribbageCard.fullDeckByRank

  private(set) var scoringProgress = ScoringProgress()

  init() {
    pegging = Pegging(turn: cribOwner.opponent())
  }

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
    pegging = Pegging(turn: cribOwner.opponent())
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
    if selected.rank == .jack {
      if cribOwner == .ada {
        adaScore += 2
      } else if cribOwner == .bob {
        bobScore += 2
      }
    }
  }

  mutating func toss(_ left: Card, _ right: Card, by: Player) {
    precondition(find(left).owner == by && find(right).owner == by, "Tossing unowned cards to crib")
    precondition(crib.count <= 2, "Crib will exceed max size")
    toss(left)
    toss(right)
  }

  func canLay(_ card: Card) -> Bool {
    !find(card).layed && (pegging.stack + [card]).sum() < 31
  }

  mutating func go(by: Player) {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(pegging.turn == by, "Player is out of order")
    if pegging.noGo {
      if by == .ada {
        bobScore += 1
      } else if by == .bob {
        adaScore += 1
      }
    }
    if by == .ada {
      pegging.adaGo = true
    } else if by == .bob {
      pegging.bobGo = true
    }
    pegging.turn.toggle()

    // check if pegging must be reset
    if pegging.bothGo {
      pegging = Pegging(turn: by.opponent())
    }
  }

  mutating func lay(_ card: Card, by: Player) {
    precondition(flipped != nil, "Flipped card has not been selected")
    precondition(pegging.turn == by, "Player is out of order")
    precondition((pegging.stack + [card]).sum() < 31, "Card would exceed 31")
    precondition(find(card).owner == by, "Card is not owned by player")
    precondition(!find(card).layed, "Card has already been layed")
    let i = findIndex(card)
    cards[i].layed = true
    let score = peg(played: pegging.stack, playing: card)
    if by == .ada {
      adaScore += score
    } else if by == .bob {
      bobScore += score
    }
    pegging.stack.append(card)
    pegging.turn.toggle()

    // check if pegging must be reset
    if pegging.stack.sum() == 31 {
      pegging = Pegging(turn: pegging.turn)
    }

    // check if pegging is over
    let adaDone = adaHand.allSatisfy { $0.layed }
    let bobDone = bobHand.allSatisfy { $0.layed }
    if adaDone && bobDone {
      pegging = Pegging(turn: cribOwner.opponent())
      scoringProgress.pegging = true
    }
  }

  // MARK: - Scoring functions

  mutating func scoreNondealer() {
    precondition(scoringProgress.pegging, "Pegging has not been completed")
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

  private mutating func retarget(cards arr: [Card], to owner: CribbageCard.Owner) {
    for i in cards.indices {
      if arr.contains(cards[i].card) {
        cards[i].owner = owner
      }
    }
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
