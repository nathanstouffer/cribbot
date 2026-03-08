import Foundation

class GameViewModel: ObservableObject {

  @Published private var game = GameModel()

  var deck: Array<Card> {
    return game.deck
  }
  
  var flippedCard: Card? {
    return game.flippedCard
  }
  
  var crib: Array<Card> {
    return game.crib
  }

}
