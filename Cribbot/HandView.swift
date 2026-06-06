import SwiftUI

struct HandView: View {

  @Binding var cards: [Card]
  @Binding var mode: HandStaging
  let isFaceUp: Bool
  let onDiscard: (Card) -> Void
  private let animationNamespace: Namespace.ID

  init(
    cards: Binding<[Card]>,
    mode: Binding<HandStaging>,
    isFaceUp: Bool,
    animationNamespace: Namespace.ID,
    onDiscard: @escaping (Card) -> Void = { _ in }
  ) {
    self._cards = cards
    self._mode = mode
    self.isFaceUp = isFaceUp
    self.animationNamespace = animationNamespace
    self.onDiscard = onDiscard
  }

  var body: some View {
    HStack(spacing: cards.count == 6 ? -30 : nil) {
      ForEach(cards) { card in
        CardView(card, isFaceUp: isFaceUp)
          .offset(x: 0, y: mode.contains(card) ? -12 : 0)
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
          .onTapGesture {
            withAnimation {
              switch mode {
              case .preThrow:
                mode.toggle(card)
              case .pegging:
                onDiscard(card)
              }
            }
          }
      }
    }
    .padding(.horizontal)
  }

}

#Preview("Pre-throw") {
  @Previewable @Namespace var namespace
  @Previewable @State var cards = Array(Card.fullDeckByRank.prefix(6))
  @Previewable @State var staging: HandStaging = .preThrow([])
  HandView(
    cards: $cards,
    mode: $staging,
    isFaceUp: true,
    animationNamespace: namespace
  )
}
