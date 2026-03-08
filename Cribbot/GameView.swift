import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      background
      //oldView
      VStack {
        computerHand
        Spacer()
        TrayView(game)
        Spacer()
        humanHand
      }
    }
  }

  var computerHand: some View {
    CardView.back()
  }
  
  var humanHand: some View {
    CardView.back()
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
