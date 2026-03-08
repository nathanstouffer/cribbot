import SwiftUI

struct HandView: View {
  @ObservedObject private var game: GameViewModel

  let cards: Array<Card>
  let isFaceUp: Bool
  
  init(game: GameViewModel, cards: Array<Card>, isFaceUp: Bool) {
    self.game = game
    self.cards = cards
    self.isFaceUp = isFaceUp
  }
  
  var sixView: some View {
    HStack {
      ZStack {  // centered
        let cardWidth: CGFloat = 80
        let overlap: CGFloat = 52
        let totalWidth = cardWidth + overlap * CGFloat(max(0, cards.count - 1))
        let mid = CGFloat(cards.count - 1) / 2.0
        ForEach(cards.indices, id: \.self) { i in
          CardView(card: cards[i], isFaceUp: isFaceUp)
            .offset(x: (CGFloat(i) - mid) * overlap)
            .zIndex(Double(i))
        }
      }
    }
    .padding(.horizontal)
  }
  
  var fourView: some View {
    HStack(spacing: 8) {
      ForEach(cards, id: \.self) { card in
        CardView(card: card, isFaceUp: isFaceUp)
      }
    }
    .padding(.horizontal)
  }
  
  var scrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(cards, id: \.self) { card in
          CardView(card: card, isFaceUp: isFaceUp)
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
