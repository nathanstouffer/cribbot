import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  @Namespace private var animationNamespace

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      background
      VStack {
        adaHand
        Spacer()
        ScoreView(score: game.adaScore).padding(20)
        ZStack {
          TrayView(game, animationNamespace: animationNamespace)
          if game.isPegging {
            PeggingView(cards: game.peggingStack, playerToLay: game.playerToLay, animationNamespace: animationNamespace)
          }
        }
        buttons
        ScoreView(score: game.bobScore)
        Spacer()
        bobHand
      }
    }
  }

  private var adaHand: some View {
    PlayerView(
      game: game, hand: game.adaHand, crib: game.showAdaCrib ? game.crib : [],
      isFaceUp: game.showAdaCards,
      allowStage: false, animationNamespace: animationNamespace)
  }

  private var bobHand: some View {
    PlayerView(
      game: game, hand: game.bobHand, crib: game.showBobCrib ? game.crib : [], isFaceUp: true,
      allowStage: true, animationNamespace: animationNamespace)
  }

  private var buttons: some View {
    HStack {
      Spacer()
      dealButton
      Spacer()
      tossButton
      Spacer()
      layButton
      Spacer()
      goButton
      Spacer()
      nextButton
      Spacer()
    }
    .padding(20)
  }

  private var dealButton: some View {
    Button("Deal") {
      withAnimation {
        game.startNewHand()
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canDeal)
  }

  private var tossButton: some View {
    Button("Toss") {
      if game.canToss {
        withAnimation {
          game.toss(game.staged[0], game.staged[1])
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canToss)
  }

  private var layButton: some View {
    Button("Lay") {
      if game.canLay {
        withAnimation {
          game.lay(game.staged[0])
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canLay)
  }

  private var goButton: some View {
    Button("Go") {
      if game.canGo {
        withAnimation {
          game.go()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canGo)
  }

  private var scoreButton: some View {
    Button("Score") {
      if game.canScore {
        withAnimation {
          game.scoreNextHand()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canScore)
  }

  private var nextButton: some View {
    Button("Next") {
      withAnimation {
        if game.stalledPegging {
          game.clearPeggingStack()
        } else if game.canScore {
          game.scoreNextHand()
        } else if game.canEndHand {
          game.endHand()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!(game.canScore || game.canEndHand || game.stalledPegging))
  }

  private var background: some View {
    Rectangle()
      .fill(.green)
      .ignoresSafeArea()
  }

}

#Preview {
  GameView(GameViewModel())
}
