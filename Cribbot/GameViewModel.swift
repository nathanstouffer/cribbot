import Foundation

class GameViewModel: ObservableObject {

  @Published private var game = Game()

  var stage: Game.HandStage {
    return game.stage
  }

  var cribOwner: Game.Player {
    return game.cribOwner
  }

  var deck: [Card] {
    return game.deck
  }

  var flippedCard: Card? {
    return game.flipped
  }

  var crib: [Card] {
    return game.crib
  }

  var isCribLocked: Bool {
    return crib.count == 4
  }

  var ada: Game.Player {
    return game.ada
  }

  var bob: Game.Player {
    return game.bob
  }

  // MARK: - Intent functions

  func shuffle() {
    game.shuffle()
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
      return card == staged
    } else {
      return false
    }
  }

  func scoreHands() {
    game.scoreHands()
  }

}
