import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      Rectangle()
        .fill(.green)
        .ignoresSafeArea()
      DeckView()
    }
  }
}

#Preview {
  GameView(GameViewModel())
}
