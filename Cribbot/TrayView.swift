import SwiftUI

struct TrayView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    VStack {
      cardStacks
      HStack(spacing: 100) {
        Button("Deal") {
          game.shuffleAndDeal()
        }
        .buttonStyle(.borderedProminent)
        Button("Reset") {
          game.resetDeck()
        }
        .buttonStyle(.borderedProminent)
      }

    }
    
  }
  
  var cardStacks: some View {
    HStack(spacing: 12) {
      deckStack
      Spacer()
      flip
      Spacer()
      crib
    }
    .padding(.horizontal)
  }
  
  var deckStack: some View {
    StackView(text: "Deck") {
      VStack(spacing: 8) {
        CardView.back()
          .overlay(
            Text("\(game.deck.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
      }
    }
  }
  
  var flip: some View {
    StackView(text: "Flip") {
      if let card = game.flippedCard {
        CardView(card: card, isFaceUp: true)
      } else {
        EmptyView()
      }
    }
  }
  
  var crib: some View {
    StackView(text: "Crib") {
      if game.crib.isEmpty {
        EmptyView()
      } else {
        CardView.back()
      }
    }
  }
  
  struct StackView<Content: View>: View {
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
}

#Preview {
  TrayView(GameViewModel())
}
