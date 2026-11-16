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
        HandView(
          game: game, cards: game.adaCards, isFaceUp: game.showAdaCards,
          animationNamespace: animationNamespace)
        Spacer()
        ScoreView(score: game.adaScore).padding(20)
        TrayView(game, animationNamespace: animationNamespace)
        buttons
        ScoreView(score: game.bobScore)
        Spacer()
        HandView(
          game: game, cards: game.bobCards, isFaceUp: true,
          animationNamespace: animationNamespace)
      }
    }
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
      scoreButton
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

  private var layButton: some View {
    Button("Lay") {
      if game.isCribLocked && game.staged.count == 1 {
        withAnimation {
          game.lay(game.staged[0])
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canLay)
  }

  private var nextButton: some View {
    Button("Next") {
      withAnimation {
        game.endHand()
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canEndHand)
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
