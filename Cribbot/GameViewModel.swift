import Foundation
import SwiftUI

/// This class utilizes the Game struct to control the state of a cribbage game
/// The computer has the role of Ada and the player has the role of Bob
class GameViewModel: ObservableObject {

  @Published private var game = Game()

  private var adaHandSelector = RelativeHandSelector()
  private var adaPegSelector = HeuristicPegSelector()
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

  var adaHand: Game.Hand {
    game.adaHand
  }

  var bobHand: Game.Hand {
    game.bobHand
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
    game.cribOwner == Game.Player.bob
  }

  var playerToLay: Bool {
    game.pegging.turn == .bob
  }

  var isCribLocked: Bool {
    crib.count == 4
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
    isPegging && staged.count == 1 && game.pegging.turn == .bob
      && (game.pegging.stack + [staged[0]]).sum() <= 31
  }

  var stalledPegging: Bool {
    isPegging && (game.pegging.stack.sum() == 31 || game.pegging.bothGo || game.allLayed)
  }

  var canGo: Bool {
    isPegging && !stalledPegging && game.pegging.turn == .bob
      && bobHand.unlayed.filter { $0.rank.peggingValue <= 31 - game.pegging.stack.sum() }.isEmpty
  }

  var canScore: Bool {
    isCribLocked && game.scoringProgress.pegging && !game.scoringProgress.isDone
  }

  var canEndHand: Bool {
    game.scoringProgress.isDone
  }

  var showAdaCards: Bool {
    true
    //isCribLocked && game.scoringProgress.pegging
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
        cards: game.adaHand.cards, ownsCrib: game.cribOwner == .ada)
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
    Task {
      try await Task.sleep(for: .seconds(1.5))
      await MainActor.run {
        withAnimation {
          // check if we are still in pegging mode
          if isPegging {
            let selected = adaPegSelector.lay(
              played: game.pegging.stack, available: adaHand.unlayed)
            if let selected = selected {
              game.lay(selected, by: .ada)
            } else {
              game.go(by: .ada)
            }
          }
        }
      }
    }
  }

  func go() {
    staged.removeAll()
    game.go(by: .bob)
    adaLay()
  }

  func lay(_ card: Card) {
    staged.removeAll()
    game.lay(card, by: .bob)
    if game.pegging.stack.sum() != 31 {
      adaLay()
    }
  }

  func clearPeggingStack() {
    game.clearPeggingStack()
    if game.pegging.turn == .ada {
      adaLay()
    }
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
    bobTossed = false
  }

  // MARK: - Staging functions

  @Published private(set) var staged = [Card]()

  func isStaged(_ card: Card) -> Bool {
    staged.contains(card)
  }
}
