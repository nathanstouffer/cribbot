import Foundation

/// This class utilizes the Game struct to control the state of a cribbage game
/// The computer has the role of Ada and the player has the role of Bob
class GameViewModel: ObservableObject {

  @Published private var game = Game()

  // TODO (stouff) find a new name for this
  var stage: Game.HandStage {
    return game.stage
  }

  var adaScore: Int {
    game.adaScore
  }

  var bobScore: Int {
    game.bobScore
  }

  // MARK: - Card accessors

  var deck: [Card] {
    return game.deck
  }

  var adaCards: [Card] {
    game.adaCards
  }

  var bobCards: [Card] {
    game.bobCards
  }

  var flippedCard: Card? {
    return game.flipped
  }

  var crib: [Card] {
    return game.crib
  }
  
  // MARK: - Indicators

  var playerOwnsCrib: Bool {
    return game.cribOwner == Game.Player.bob
  }

  var isCribLocked: Bool {
    return crib.count == 4
  }
  
  var canToss: Bool {
    !isCribLocked && staged.count == 2
  }
  
  var canLay: Bool {
    isCribLocked && staged.count == 1
  }

  // MARK: - Intent functions

  func startNewHand() {
    game.shuffle()
    game.deal()
  }

  func stage(_ card: Card) {
    staged.append(card)
  }

  func unstage(_ card: Card) {
    staged.removeAll(where: { $0 == card })
  }

  func toss(_ left: Card, _ right: Card) {
    staged.removeAll()
    game.toss(left, right, by: .bob)
    game.toss(game.adaCards[0], game.adaCards[1], by: .ada)
    game.flip()
  }

  func lay(_ card: Card) {
    game.lay(card, by: .bob)
  }

  func scoreHands() {
    game.scoreHands()
  }

  func clearHand() {
    game.shuffle()
  }

  // MARK: - Staging functions

  @Published private(set) var staged = [Card]()

  func isStaged(_ card: Card) -> Bool {
    staged.contains(card)
  }
}
