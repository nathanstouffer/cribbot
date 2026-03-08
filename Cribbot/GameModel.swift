import Foundation

struct GameModel {

  var human = Player()
  var bot = Player()

  // TODO (stouff) add some sort of tracking of who is first

  var deck = Deck()
  var flipped: Card? = nil
  var crib: [Card] = []

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
