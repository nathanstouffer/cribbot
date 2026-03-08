import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }
  
  // TODO (stouff) delete this
  var oldView: some View {
    DeckView()
  }
  
  // TODO (stouff) move this into the main view
  var newView: some View {
    ZStack {
      Group {
        ForEach(game.deck, id: \.self) { card in
          CardView.back(shadowRadius: 0)
        }
      }
        .overlay(
          Text("\(game.deck.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
    }
  }

  var body: some View {
    ZStack {
      background
      //oldView
      VStack {
        computerHand
        Spacer()
        tray
        Spacer()
        humanHand
      }
    }
  }
  
  var tray: some View {
    CardView.back()
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
