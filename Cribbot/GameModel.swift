import Foundation

struct GameModel {

  private(set) var human = Player()
  private(set) var bot = Player()

  // TODO (stouff) add some sort of tracking of who is first

  private(set) var deck = Card.fullDeckByRank
  private(set) var flipped: Card? = nil
  private(set) var crib: [Card] = []

  func shuffleAndDeal() {

  }

  func flip() {

  }

}

struct Hand {

  var cards: [Card] = []

}

struct Player {

  var score: Int = 0
  var hand = Hand()

}
