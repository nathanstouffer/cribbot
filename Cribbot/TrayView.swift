import SwiftUI

struct TrayView: View {

  @ObservedObject private var game: GameViewModel
  private let animationNamespace: Namespace.ID

  init(_ game: GameViewModel, animationNamespace: Namespace.ID) {
    self.game = game
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    HStack(spacing: 12) {
      deck
      Spacer()
      flip
      Spacer()
      crib
    }
    .padding(.horizontal)
  }

  var deck: some View {
    StackView(text: "Deck") {
      VStack(spacing: 8) {
        ZStack {
          ForEach(game.deck) { card in
            CardView.back(shadowRadius: 0)
              .matchedGeometryEffect(id: card.id, in: animationNamespace)
          }
        }
        .overlay(
          Text("\(game.deck.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40)
        )
      }
    }
  }

  var flip: some View {
    StackView(text: "Flip") {
      if let card = game.flippedCard {
        CardView(card, isFaceUp: true)
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
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
        ForEach(game.crib) { card in
          CardView(card, isFaceUp: false)
            .matchedGeometryEffect(id: card.id, in: animationNamespace)
        }
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
