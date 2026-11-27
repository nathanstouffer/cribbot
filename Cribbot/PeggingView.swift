import SwiftUI

struct PeggingView: View {

  let cards: [Card]
  let playerToLay: Bool

  private let animationNamespace: Namespace.ID

  @State private var arrowRotationAngle = 0.0

  init(cards: [Card], playerToLay: Bool, animationNamespace: Namespace.ID) {
    self.cards = cards
    self.playerToLay = playerToLay
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    ZStack {
      placeholder
      HStack {
        stack
        Spacer()
        VStack {
          turnIndicator.padding(.bottom, 10)
          total
        }.padding(.trailing, 30)
      }
    }
    .padding()
    .background(Color.black.opacity(0.8))
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
        arrowRotationAngle = playerToLay ? 180.0 : 0.0
      }
      .onChange(of: playerToLay) { _, _ in
        withAnimation(.easeInOut(duration: 0.4)) {
          arrowRotationAngle += 180.0
        }
      }
  }

  var placeholder: some View {
    CardView(Card(.ace, .spades), isFaceUp: true)
      .padding(20)
      .hidden()
  }
}

#Preview {
  struct PreviewWrapper: View {
    @Namespace private var namespace

    var body: some View {
      VStack {
        Spacer()
        PeggingView(
          cards: [
            Card(.three, .spades), Card(.eight, .hearts), Card(.four, .spades),
            Card(.ten, .diamonds),
          ],
          playerToLay: false,
          animationNamespace: namespace
        )
        Spacer()
        PeggingView(
          cards: [],
          playerToLay: true,
          animationNamespace: namespace
        )
        Spacer()
        PeggingView(
          cards: [Card(.eight, .spades)],
          playerToLay: true,
          animationNamespace: namespace
        )
        Spacer()
        PeggingView(
          cards: [
            Card(.ace, .spades), Card(.two, .spades), Card(.ace, .hearts), Card(.two, .hearts),
            Card(.ace, .diamonds), Card(.two, .diamonds), Card(.ace, .clubs), Card(.two, .clubs),
          ],
          playerToLay: false,
          animationNamespace: namespace
        )
        Spacer()
      }
    }
  }
  return PreviewWrapper()
}
