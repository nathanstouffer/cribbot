import Foundation
import SwiftUI

/// This class utilizes the Game struct to control the state of a cribbage game
/// The computer has the role of Ada and the player has the role of Bob
class GameViewModel: ObservableObject {

  @Published private var game = Game()

  private var adaHandSelector = RelativeHandSelector()
  private var adaPegSelector = RandomPegSelector()
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

  var adaUnlayedCards: [Card] {
    game.adaHand.filter { !$0.layed }.map { $0.card }
  }
  
  var bobUnlayedCards: [Card] {
    game.bobHand.filter { !$0.layed }.map { $0.card }
  }

  var flippedCard: Card? {
    game.flipped
  }

  var crib: [Card] {
    game.crib
  }

  var peggingStack: [Card] {
    game.pegging.stack
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
  
  var isPegging: Bool {
    isCribLocked && !game.scoringProgress.pegging
  }

  var canLay: Bool {
    isCribLocked && staged.count == 1 && !game.scoringProgress.pegging && game.pegging.turn == .bob
  }

  var canScore: Bool {
    isCribLocked && game.scoringProgress.pegging && !game.scoringProgress.isDone
  }

  var canEndHand: Bool {
    game.scoringProgress.isDone
  }

  var showAdaCards: Bool {
    isCribLocked && game.scoringProgress.pegging
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
            if game.pegging.turn == .ada {
              adaLay()
            }
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
      if game.pegging.turn == .ada {
        adaLay()
      }
    }
  }

  func adaLay() {
    let selected = adaPegSelector.lay(played: [], available: adaCards)
    if let selected = selected {
      game.lay(selected, by: .ada)
    } else {
      game.go(by: .ada)
    }
  }

  func lay(_ card: Card) {
    staged.removeAll()
    game.lay(card, by: .bob)
    adaLay()
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
