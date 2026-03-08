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
    // Deck and controls
    HStack(spacing: 12) {
      TrayStackView(text: "Deck") {
        VStack(spacing: 8) {
          CardView.back()
            .overlay(
              Text("\(game.deck.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
        }
      }
      Spacer()
      TrayStackView(text: "Flip") {
        if let card = game.flippedCard {
          CardView(card: card, isSelected: false, onToggle: nil)
        } else {
          EmptyView()
        }
      }
      Spacer()
      TrayStackView(text: "Crib") {
        if game.crib.isEmpty {
          EmptyView()
        } else {
          CardView.back()
        }
      }
    }
    .padding(.horizontal)
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

struct TrayStackView<Content: View>: View {
  let text: String
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack {
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .stroke(.white)
          .frame(width: 93, height: 133)
        content()
      }
      Text(text)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  GameView(GameViewModel())
}
