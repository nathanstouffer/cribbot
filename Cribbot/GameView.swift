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
          game: game, cards: game.adaCards, isFaceUp: game.stage == .scoringHands,
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
      scoreButton
      Spacer()
      resetButton
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
      if game.isCribLocked {
        withAnimation {
          game.scoreHands()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.isCribLocked)
  }

  private var layButton: some View {
    Button("Lay") {
      if game.isCribLocked && game.staged.count == 1 {
        withAnimation {

        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(game.staged.count != 1 || !game.isCribLocked)
  }

  private var resetButton: some View {
    Button("Reset") {
      withAnimation {
        game.clearHand()
      }
    }
    .buttonStyle(.borderedProminent)
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
