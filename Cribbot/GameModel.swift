import Foundation

struct GameModel {

  enum HandStage {
    case initial
    case selectingCrib
    case scoringHands
  }

  enum CribOwner: CaseIterable {
    case computer
    case human

    mutating func toggle() {
      if self == .computer {
        self = .human
      } else {
        self = .computer
      }
    }
  }

  private(set) var computer = Player()
  private(set) var human = Player()

  private(set) var cribOwner: CribOwner = CribOwner.allCases.randomElement()!

  private(set) var deck = Card.fullDeckByRank
  private(set) var flippedCard: Card?
  private(set) var crib: [Card] = []
  private(set) var isCribLocked = false

  private(set) var stagedForCrib: [Card] = []
  private(set) var stagedForLay: Card?

  private(set) var stage = HandStage.initial

  mutating func resetDeck() {
    deck = Card.fullDeckByRank
    flippedCard = nil
    crib = []
    isCribLocked = false
    human.hand.reset()
    computer.hand.reset()
    stagedForCrib = []
    stagedForLay = nil
    stage = .initial
    cribOwner.toggle()
  }

  mutating func shuffleAndDeal() {
    resetDeck()
    deck.shuffle()
    var first = [Card]()
    var second = [Card]()
    for _ in 0..<6 {
      // TODO (stouff) adapt this to who is going first
      first.append(deck[0])
      deck.removeFirst()
      second.append(deck[0])
      deck.removeFirst()
    }
    if cribOwner == .computer {
      computer.hand = first
      human.hand = second
    } else {
      human.hand = first
      computer.hand = second
    }
    stage = .selectingCrib
  }

  mutating func flip() {
    flippedCard = deck[0]
    deck.removeFirst()
  }

  mutating func stageForCrib(_ card: Card) {
    if !stagedForCrib.contains(card) {
      stagedForCrib.insert(card, at: 0)
      if stagedForCrib.count > 2 {
        stagedForCrib.removeLast()
      }
    }
  }

  mutating func unstageForCrib(_ card: Card) {
    stagedForCrib.removeAll(where: { $0.id == card.id })
  }

  mutating func throwToCrib() {
    if stagedForCrib.count == 2 {
      crib.append(stagedForCrib[0])
      crib.append(stagedForCrib[1])
      human.hand.removeAll(where: { $0 == stagedForCrib[0] })
      human.hand.removeAll(where: { $0 == stagedForCrib[1] })
      stagedForCrib = []
      crib.append(computer.hand[0])
      crib.append(computer.hand[1])
      computer.hand.removeFirst()
      computer.hand.removeFirst()
      flip()
      isCribLocked = true
      stage = .scoringHands
    }
  }

  mutating func stageForLay(_ card: Card) {
    stagedForLay = card
  }

  mutating func unstageForLay(_ card: Card) {
    stagedForLay = nil
  }

  mutating func lay(_ card: Card) {
    // TODO: implement this
  }

  mutating func scoreHands() {
    if let flippedCard = flippedCard {
      computer.score += score(hand: computer.hand, flip: flippedCard, isCrib: false)
      human.score += score(hand: human.hand, flip: flippedCard, isCrib: false)
    }

  }

}

struct Player {

  var score: Int = 0
  var hand = [Card]()

}

extension [Card] {
  mutating func reset() {
    self = []
  }
}
