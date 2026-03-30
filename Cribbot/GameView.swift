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
          game: game, cards: game.computer.hand, isFaceUp: false,
          animationNamespace: animationNamespace)
        Spacer()
        TrayView(game, animationNamespace: animationNamespace)
        buttons
        ScoreView(computer: game.computer, human: game.human)
        Spacer()
        HandView(
          game: game, cards: game.human.hand, isFaceUp: true,
          animationNamespace: animationNamespace)
      }
    }
  }

  private var buttons: some View {
    HStack {
      Spacer()
      dealButton
      Spacer()
      throwButton
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
        game.shuffleAndDeal()
      }
    }
    .buttonStyle(.borderedProminent)
  }

  private var throwButton: some View {
    Button("Throw") {
      if game.stagedForCrib.count == 2 {
        withAnimation {
          game.throwToCrib()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(game.stagedForCrib.count != 2 || game.isCribLocked)
  }

  private var scoreButton: some View {
    Button("Score") {
      if (game.isCribLocked) {
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
      if game.isCribLocked && game.stagedForLay != nil {
        withAnimation {

        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(game.stagedForLay == nil || !game.isCribLocked)
  }

  private var resetButton: some View {
    Button("Reset") {
      withAnimation {
        game.resetDeck()
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
