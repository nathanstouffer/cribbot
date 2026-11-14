import Foundation

struct Game {

  enum HandStage {
    case initial
    case selectingCrib
    case scoringHands
  }

  enum CribOwner: CaseIterable {
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

  private(set) var ada = Player()
  private(set) var bob = Player()

  private(set) var cribOwner: CribOwner = CribOwner.allCases.randomElement()!

  private(set) var cards = CribbageCard.fullDeckByRank

  private(set) var stage = HandStage.initial

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
  }

  mutating func deal() {
    for i in 0..<6 {
      cards[2 * i + 0].owner = .ada
      cards[2 * i + 1].owner = .bob
    }
  }

  mutating func flip() {
    let deckIndices = cards.indices.filter { cards[$0].owner == .deck }
    if let randomIndex = deckIndices.randomElement() {
      cards[randomIndex].owner = .flip
    }
  }

  mutating func toss(_ card: Card) {
    guard let index = findIndex(card) else { return }
    cards[index].owner = .crib
  }

  mutating func lay(_ card: Card) {
    guard let index = findIndex(card) else { return }
    cards[index].layed = true
  }

  mutating func scoreHands() {
    if cribOwner == .ada {
      bob.score += score(hand: bobCards, flip: flipped!, isCrib: false)
      ada.score += score(hand: adaCards, flip: flipped!, isCrib: false)
      ada.score += score(hand: crib, flip: flipped!, isCrib: true)
    }
  }

  private func findIndex(_ card: Card) -> Int? {
    cards.firstIndex(where: { $0.id == card.id })
  }

}

struct Player {

  var score: Int = 0

}
