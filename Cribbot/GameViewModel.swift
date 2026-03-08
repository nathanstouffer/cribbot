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
  
  var stagedForLay: Card? {
    return game.stagedForLay
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
  
  func stageForLay(_ card: Card) {
    game.stageForLay(card)
  }
  
  func unstageForLay(_ card: Card) {
    game.unstageForLay(card)
  }
  
  func lay(_ card: Card) {
    game.lay(card)
  }
  
  func isStagedForLay(_ card: Card) -> Bool {
    if let staged = game.stagedForLay {
      return true
    } else {
      return false
    }
  }

}
