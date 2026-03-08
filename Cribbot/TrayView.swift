import SwiftUI

struct TrayView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    HStack(spacing: 12) {
      StackView(text: "Deck") {
        VStack(spacing: 8) {
          CardView.back()
            .overlay(
              Text("\(game.deck.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
        }
      }
      Spacer()
      StackView(text: "Flip") {
        if let card = game.flippedCard {
          CardView(card: card, isSelected: false, onToggle: nil)
        } else {
          EmptyView()
        }
      }
      Spacer()
      StackView(text: "Crib") {
        if game.crib.isEmpty {
          EmptyView()
        } else {
          CardView.back()
        }
      }
    }
    .padding(.horizontal)
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
