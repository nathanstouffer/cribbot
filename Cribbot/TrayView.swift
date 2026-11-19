import SwiftUI

struct TrayView: View {

  @ObservedObject private var game: GameViewModel
  @State private var arrowRotationAngle = 0.0
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
    ZStack {
      StackView(text: "Crib") {
        if game.cribInTray {
          ZStack {
            ForEach(game.crib) { card in
              CardView(card, isFaceUp: false)
                .matchedGeometryEffect(id: card.id, in: animationNamespace)
            }
            cribIndicator
          }
        } else {
          cribIndicator
        }
      }
    }
  }

  var cribIndicator: some View {
    Image(systemName: "arrowshape.up")
      .foregroundStyle(.secondary)
      .font(.largeTitle)
      .rotationEffect(.degrees(arrowRotationAngle))
      .onAppear {
        arrowRotationAngle = game.playerOwnsCrib ? 180.0 : 0.0
      }
      .onChange(of: game.playerOwnsCrib) { _, _ in
        withAnimation(.easeInOut(duration: 0.4)) {
          arrowRotationAngle += 180.0
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
