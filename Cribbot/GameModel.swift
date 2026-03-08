import Foundation

struct GameModel {

  private(set) var computer = Player()
  private(set) var human = Player()

  // TODO (stouff) add some sort of tracking of who is first

  private(set) var deck = Card.fullDeckByRank
  private(set) var flippedCard: Card? = nil
  private(set) var crib: [Card] = []
  private(set) var isCribLocked = false

  private(set) var stagedForCrib: Array<Card> = []

  mutating func resetDeck() {
    deck = Card.fullDeckByRank
    flippedCard = nil
    crib = []
    isCribLocked = false
    human.hand.reset()
    computer.hand.reset()
  }

  mutating func shuffleAndDeal() {
    resetDeck()
    deck.shuffle()
    for _ in 0..<6 {
      // TODO (stouff) adapt this to who is going first
      computer.hand.cards.append(deck[0])
      deck.removeFirst()
      human.hand.cards.append(deck[0])
      deck.removeFirst()
    }
  }

  mutating func flip() {
    flippedCard = deck[0]
    deck.removeFirst()
  }
  
  mutating func stageForCrib(_ card: Card) {
    stagedForCrib.insert(card, at: 0)
    if stagedForCrib.count > 2 {
      stagedForCrib.removeLast()
    }
  }
  
  mutating func throwToCrib() {
    if stagedForCrib.count == 2 {
      crib.append(stagedForCrib[0])
      crib.append(stagedForCrib[1])
      stagedForCrib = []
      crib.append(computer.hand.cards[0])
      crib.append(computer.hand.cards[1])
      computer.hand.cards.removeFirst()
      computer.hand.cards.removeFirst()
      isCribLocked = true
    }
  }

}

struct Hand {

  var cards: [Card] = []

  mutating func reset() {
    cards = []
  }

}

struct Player {

  var score: Int = 0
  var hand = Hand()

}
