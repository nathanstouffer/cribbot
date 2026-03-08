import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      background
      VStack {
        HandView(game: game, cards: game.computer.hand.cards, isFaceUp: false)
        Spacer()
        TrayView(game)
        Spacer()
        throwButton
        HandView(game: game, cards: game.human.hand.cards, isFaceUp: true)
      }
    }
  }
  
  private var throwButton: some View {
    Button("Throw") {
      game.throwToCrib()
    }
      .buttonStyle(.borderedProminent)
      .disabled(game.stagedForCrib.count != 2 || game.isCribLocked)
      .padding(20)
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
