import SwiftUI

struct HandView: View {
  @ObservedObject private var game: GameViewModel

  let cards: [Card]
  let isFaceUp: Bool
  private let animationNamespace: Namespace.ID

  init(game: GameViewModel, cards: [Card], isFaceUp: Bool, animationNamespace: Namespace.ID) {
    self.game = game
    self.cards = cards
    self.isFaceUp = isFaceUp
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    HStack(spacing: cards.count == 6 ? -30 : nil) {
      ForEach(Array(cards.enumerated()), id: \.element) { i, card in
        CardView(card, isFaceUp: isFaceUp)
          .offset(x: 0, y: game.isStaged(card) ? -12 : 0)
          .zIndex(Double(i))
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
          .onTapGesture {
            onTap(card: card)
          }
      }
    }
    .padding(.horizontal)
  }

  private func onTap(card: Card) {
    if isFaceUp {
      withAnimation {
        if !game.isStaged(card) {
          game.stage(card)
        } else {
          game.unstage(card)
        }
      }
    }
  }

}
