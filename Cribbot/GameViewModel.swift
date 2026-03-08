import Foundation

class GameViewModel: ObservableObject {

  @Published private var game = GameModel()

  var deck: Array<Card> {
    return game.deck
  }

}
