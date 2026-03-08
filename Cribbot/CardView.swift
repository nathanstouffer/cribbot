import SwiftUI

struct CardView: View {

  var card: Card
  var isFaceUp = false

  var body: some View {
    ZStack {
      front.opacity(isFaceUp ? 1 : 0)
      CardView.back().opacity(isFaceUp ? 0 : 1)
    }
    .frame(width: 80, height: 120)
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(.isButton)
    .accessibilityLabel("\(card.rank.display) of \(String(describing: card.suit))")
  }

  static func back(shadowRadius: CGFloat = 4) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(.white)
        .frame(width: 80, height: 120)
      RoundedRectangle(cornerRadius: 5)
        .fill(
          LinearGradient(
            colors: [.orange, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .frame(width: 72, height: 112)
        .shadow(radius: shadowRadius)
    }
  }

  private var front: some View {
    ZStack {
      RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.5), radius: 2)
      indexes
      pips
    }
  }

  private var indexes: some View {
    VStack {
      HStack {  // top left
        index
        Spacer()
      }
      Spacer()
      HStack {  // bottom right
        Spacer()
        index
          .rotationEffect(Angle(degrees: 180))
      }
    }
  }

  private var index: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("\(card.rank == Card.Rank.ten ? "" : " ")\(card.rank.display)")
        .font(.caption)
        .bold()
        .foregroundColor(card.suit.color)
      Text(card.suit.symbol)
        .font(.caption2)
    }
    .padding(6)
  }

  private var pips: some View {
    Text("\(card.rank.display)\(card.suit.symbol)")
      .bold()
      .font(.title2)
      .foregroundStyle(card.suit.color)
  }

  private struct Config {

  }
}

#Preview("Grid of cards") {
  ScrollView {
    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
      ForEach(Card.fullDeckByRank) { card in
        CardView(card: card, isFaceUp: true)
      }
    }
    .padding()
  }
}
