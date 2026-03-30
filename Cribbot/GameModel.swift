import Foundation

struct GameModel {

  private(set) var computer = Player()
  private(set) var human = Player()

  // TODO (stouff) add some sort of tracking of who is first

  private(set) var deck = Card.fullDeckByRank
  private(set) var flippedCard: Card?
  private(set) var crib: [Card] = []
  private(set) var isCribLocked = false

  private(set) var stagedForCrib: [Card] = []
  private(set) var stagedForLay: Card?

  mutating func resetDeck() {
    deck = Card.fullDeckByRank
    flippedCard = nil
    crib = []
    isCribLocked = false
    human.hand.reset()
    computer.hand.reset()
    stagedForCrib = []
    stagedForLay = nil
  }

  mutating func shuffleAndDeal() {
    resetDeck()
    deck.shuffle()
    for _ in 0..<6 {
      // TODO (stouff) adapt this to who is going first
      computer.hand.append(deck[0])
      deck.removeFirst()
      human.hand.append(deck[0])
      deck.removeFirst()
    }
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

extension Array<Card> {
  mutating func reset() {
    self = []
  }
}
