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

  var sixView: some View {
    HStack {
      ZStack {
        let overlap: CGFloat = 52
        let mid = CGFloat(cards.count - 1) / 2.0
        ForEach(Array(cards.enumerated()), id: \.element) { i, card in
          let isStaged = game.stagedForCrib.contains(card)
          CardView(card, isFaceUp: isFaceUp)
            .offset(x: (CGFloat(i) - mid) * overlap, y: isStaged ? -12 : 0)
            .zIndex(Double(i))
            .matchedGeometryEffect(id: card.id, in: animationNamespace)
            .onTapGesture {
              if isFaceUp {
                if !game.isStagedForCrib(card) {
                  game.stageForCrib(card)
                } else {
                  game.unstageForCrib(card)
                }
              }
            }
        }
      }
      .animation(.default, value: game.stagedForCrib)
    }
    .padding(.horizontal)
  }

  var fourView: some View {
    HStack(spacing: 8) {
      ForEach(cards) { card in
        let isStaged = game.stagedForLay != nil && game.stagedForLay!.id == card.id
        CardView(card, isFaceUp: isFaceUp)
          .offset(x: 0, y: isStaged ? -12 : 0)
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
          .onTapGesture {
            if isFaceUp {
              if !game.isStagedForLay(card) {
                game.stageForLay(card)
              } else {
                game.unstageForLay(card)
              }
            }
          }
      }
    }
    .animation(.default, value: game.stagedForLay)
    .padding(.horizontal)
  }

  var scrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(cards) { card in
          CardView(card, isFaceUp: isFaceUp)
            .matchedGeometryEffect(id: card.id, in: animationNamespace)
        }
      }
      .padding(.horizontal)
    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      if cards.count == 0 {
        CardView.back().opacity(0)
      } else if cards.count == 6 {
        sixView
      } else if cards.count == 4 {
        fourView
      } else {
        scrollView
      }
    }
  }
}
