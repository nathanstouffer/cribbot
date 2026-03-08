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
  
  var isCribLocked: Bool {
    return game.isCribLocked
  }
  
  var stagedForCrib: Array<Card> {
    return game.stagedForCrib
  }
  
  var computer: Player {
    return game.computer
  }
  
  var human: Player {
    return game.human
  }

  // MARK: - Intent functions
  
  func resetDeck() {
    game.resetDeck()
  }
  
  func shuffleAndDeal() {
    game.resetDeck()
    game.shuffleAndDeal()
  }
  
  func stageForCrib(_ card: Card) {
    game.stageForCrib(card)
  }
  
  func throwToCrib() {
    game.throwToCrib()
  }
  
}
