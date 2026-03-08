import SwiftUI

struct HandView: View {
  @ObservedObject private var game: GameViewModel

  let cards: [Card]
  let isFaceUp: Bool

  init(game: GameViewModel, cards: [Card], isFaceUp: Bool) {
    self.game = game
    self.cards = cards
    self.isFaceUp = isFaceUp
  }

  var sixView: some View {
    HStack {
      ZStack {
        let overlap: CGFloat = 52
        let mid = CGFloat(cards.count - 1) / 2.0
        ForEach(Array(cards.enumerated()), id: \.element) { i, card in
          let staged = game.stagedForCrib.contains(card)
          CardView(card, isFaceUp: isFaceUp)
            .offset(x: (CGFloat(i) - mid) * overlap, y: staged ? -12 : 0)
            .zIndex(Double(i))
            .onTapGesture {
              if isFaceUp {
                game.stageForCrib(card)
              }
            }
        }
      }
      .animation(.default, value: self.game.stagedForCrib)

    }
    .padding(.horizontal)
  }

  var fourView: some View {
    HStack(spacing: 8) {
      ForEach(cards) { card in
        CardView(card, isFaceUp: isFaceUp)
      }
    }
    .padding(.horizontal)
  }

  var scrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(cards) { card in
          CardView(card, isFaceUp: isFaceUp)
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
