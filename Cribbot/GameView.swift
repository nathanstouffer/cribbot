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
        buttons
        HandView(game: game, cards: game.human.hand.cards, isFaceUp: true)
      }
    }
  }

  private var buttons: some View {
    HStack() {
      Spacer()
      dealButton
      Spacer()
      throwButton
      Spacer()
      layButton
      Spacer()
      resetButton
      Spacer()
    }
    .padding(20)
  }
  
  private var dealButton: some View {
    Button("Deal") {
      game.shuffleAndDeal()
    }
    .buttonStyle(.borderedProminent)
  }
  
  private var throwButton: some View {
    Button("Throw") {
      if game.stagedForCrib.count == 2 {
        game.throwToCrib()
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(game.stagedForCrib.count != 2 || game.isCribLocked)
  }
  
  private var layButton: some View {
    Button("Lay") {
      if game.isCribLocked && game.stagedForLay != nil {
        
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(game.stagedForLay == nil || !game.isCribLocked)
  }
  
  private var resetButton: some View {
    Button("Reset") {
      game.resetDeck()
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
