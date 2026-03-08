import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      background
      VStack {
        HandView(cards: game.computer.hand.cards, isFaceUp: false)
        Spacer()
        TrayView(game)
        Spacer()
        HandView(cards: game.human.hand.cards, isFaceUp: true)
      }
    }
  }

  private var background: some View {
    Rectangle()
      .fill(.green)
      .ignoresSafeArea()
  }
  
  struct HandView: View {
    let cards: Array<Card>
    let isFaceUp: Bool
    
    var body: some View {
      VStack(alignment: .center, spacing: 10) {
        let cardWidth: CGFloat = 80
        let overlap: CGFloat = 52
        if cards.count == 0 {
          CardView.back().opacity(0)
        } else if cards.count == 6 {
          let totalWidth = cardWidth + overlap * CGFloat(max(0, cards.count - 1))
          let mid = CGFloat(cards.count - 1) / 2.0
          HStack {
            Spacer()
            ZStack {  // centered
              ForEach(cards.indices, id: \.self) { i in
                CardView(card: cards[i], isFaceUp: isFaceUp)
                  .offset(x: (CGFloat(i) - mid) * overlap)
                  .zIndex(Double(i))
              }
            }
            .frame(width: totalWidth, height: 140)
            Spacer()
          }
          .padding(.horizontal)
        } else if cards.count == 4 {
          HStack(spacing: 8) {
            Spacer()
            ForEach(cards, id: \.self) { card in
              CardView(card: card, isFaceUp: isFaceUp)
            }
            Spacer()
          }
          .padding(.horizontal)
        } else {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
              ForEach(cards, id: \.self) { card in
                CardView(card: card, isFaceUp: isFaceUp)
              }
            }
            .padding(.horizontal)
          }
        }
      }
    }
  }
}

#Preview {
  GameView(GameViewModel())
}
