import SwiftUI

struct PeggingView: View {

  @ObservedObject private var game: GameViewModel
  let cards: [Card]

  private let animationNamespace: Namespace.ID

  @State private var arrowRotationAngle = 0.0

  init(_ game: GameViewModel, cards: [Card], animationNamespace: Namespace.ID) {
    self.game = game
    self.cards = cards
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    if game.isPegging {
      ZStack {
        HStack {
          stack
          Spacer()
          VStack {
            turnIndicator.padding(.bottom, 10)
            total
          }.padding(.trailing, 30)
        }
        .padding()
        .background(Color.black.opacity(0.8))
      }
    } else {
      EmptyView()
    }
  }

  var stack: some View {
    HStack(spacing: -60) {
      ForEach(Array(cards.enumerated()), id: \.element) { i, card in
        CardView(card, isFaceUp: true)
          .zIndex(Double(i))
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
      }
    }
    .padding(.horizontal)
  }

  var total: some View {
    Text("Total: \(cards.sum())")
      .foregroundStyle(.white)
      .font(.title2)
      .contentTransition(.numericText(value: Double(cards.sum())))
  }

  var turnIndicator: some View {
    Image(systemName: "arrowshape.up")
      .foregroundStyle(.white)
      .font(.largeTitle)
      .rotationEffect(.degrees(arrowRotationAngle))
      .onAppear {
        arrowRotationAngle = game.playerToLay ? 180.0 : 0.0
      }
      .onChange(of: game.playerToLay) { _, _ in
        withAnimation(.easeInOut(duration: 0.4)) {
          arrowRotationAngle += 180.0
        }
      }
  }
}

#Preview {
  struct PreviewWrapper: View {
    @Namespace private var namespace

    var body: some View {
      PeggingView(
        GameViewModel(),
        cards: [
          Card(.three, .spades), Card(.eight, .hearts), Card(.four, .spades), Card(.ten, .diamonds),
        ],
        animationNamespace: namespace
      )
    }
  }
  return PreviewWrapper()
}
