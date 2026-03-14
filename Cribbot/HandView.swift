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
    ZStack {
      let overlap: CGFloat = 52
      let mid = CGFloat(cards.count - 1) / 2.0
      ForEach(Array(cards.enumerated()), id: \.element) { i, card in
        let isStaged = game.stagedForCrib.contains(card) || game.isStagedForLay(card)
        CardView(card, isFaceUp: isFaceUp)
          .offset(x: (CGFloat(i) - mid) * overlap, y: isStaged ? -12 : 0)
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
        if cards.count == 6 {
          if !game.isStagedForCrib(card) {
            game.stageForCrib(card)
          } else {
            game.unstageForCrib(card)
          }
        } else {
          if !game.isStagedForLay(card) {
            game.stageForLay(card)
          } else {
            game.unstageForLay(card)
          }
        }
      }
    }
  }

}
