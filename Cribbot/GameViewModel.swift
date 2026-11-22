import Foundation
import SwiftUI

/// This class utilizes the Game struct to control the state of a cribbage game
/// The computer has the role of Ada and the player has the role of Bob
class GameViewModel: ObservableObject {

  @Published private var game = Game()

  private var adaHandSelector = RelativeHandSelector()
  private var bobTossed = false

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

  var showCribInTray: Bool {
    !scoringCrib && !hasScoredCrib
  }

  var canDeal: Bool {
    game.deck.count == 52
  }

  var canToss: Bool {
    !bobTossed && staged.count == 2
  }

  var canLay: Bool {
    isCribLocked && staged.count == 1 && !game.scoringProgress.pegging
  }

  var canScore: Bool {
    isCribLocked && game.scoringProgress.pegging && !game.scoringProgress.isDone
  }

  var canEndHand: Bool {
    game.scoringProgress.isDone
  }

  var showAdaCards: Bool {
    isCribLocked
  }

  var scoringCrib: Bool {
    isCribLocked && game.scoringProgress.onCrib
  }

  var scoringAdaCrib: Bool {
    scoringCrib && game.cribOwner == .ada
  }

  var scoringBobCrib: Bool {
    scoringCrib && game.cribOwner == .bob
  }

  var hasScoredCrib: Bool {
    game.scoringProgress.isDone
  }

  var hasScoredAdaCrib: Bool {
    hasScoredCrib && game.cribOwner == .ada
  }

  var hasScoredBobCrib: Bool {
    hasScoredCrib && game.cribOwner == .bob
  }

  var showAdaCrib: Bool {
    scoringAdaCrib || hasScoredAdaCrib
  }

  var showBobCrib: Bool {
    scoringBobCrib || hasScoredBobCrib
  }

  // MARK: - Intent functions

  func startNewHand() {
    game.shuffle()
    game.deal()
    Task {
      let adaToss = await adaHandSelector.toss(
        cards: game.adaCards, ownsCrib: game.cribOwner == .ada)
      guard adaToss.count == 2 else {
        fatalError("Ada tosses incorrect number of cards (2)")
      }
      await MainActor.run {
        withAnimation {
          game.toss(adaToss[0], adaToss[1], by: .ada)
          if isCribLocked {
            game.flip()
          }
        }
      }
    }
  }

  func stage(_ card: Card) {
    if !isStaged(card) {
      staged.append(card)
      let max = isCribLocked ? 1 : 2
      while staged.count > max {
        staged.remove(at: 0)
      }
    }
  }

  func unstage(_ card: Card) {
    staged.removeAll(where: { $0 == card })
  }

  func toss(_ left: Card, _ right: Card) {
    staged.removeAll()
    game.toss(left, right, by: .bob)
    bobTossed = true
    if isCribLocked {
      game.flip()
    }
  }

  func lay(_ card: Card) {
    game.lay(card, by: .bob)
  }

  func scoreNextHand() {
    if game.scoringProgress.dealerHand {
      game.scoreCrib()
    } else if game.scoringProgress.nondealerHand {
      game.scoreDealer()
    } else {
      game.scoreNondealer()
    }
  }

  func endHand() {
    game.shuffle()
    game.toggleCrib()
  }

  // MARK: - Staging functions

  @Published private(set) var staged = [Card]()

  func isStaged(_ card: Card) -> Bool {
    staged.contains(card)
  }
}
