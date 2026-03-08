import Foundation

class GameViewModel: ObservableObject {

  @Published private var game = GameModel()

  var deck: [Card] {
    return game.deck
  }

  var flippedCard: Card? {
    return game.flippedCard
  }

  var crib: [Card] {
    return game.crib
  }

  var isCribLocked: Bool {
    return game.isCribLocked
  }

  var stagedForCrib: [Card] {
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
  
  func unstageForCrib(_ card: Card) {
    game.unstageForCrib(card)
  }

  func throwToCrib() {
    game.throwToCrib()
  }
  
  func isStagedForCrib(_ card: Card) -> Bool {
    return game.stagedForCrib.contains(card)
  }

}
