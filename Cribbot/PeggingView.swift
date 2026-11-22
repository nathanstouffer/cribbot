import SwiftUI

struct PeggingView: View {

  @ObservedObject private var game: GameViewModel
  let cards: [Card]

  private let animationNamespace: Namespace.ID

  @State private var delta: Int?
  @State private var animateDelta = false

  private static let animationDuration = 2.0

  init(_ game: GameViewModel, cards: [Card], animationNamespace: Namespace.ID) {
    self.game = game
    self.cards = cards
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    if cards.isEmpty {
      EmptyView()
    } else {
      ZStack {
        HStack {
          stack
          Spacer()
          total.padding(.trailing, 30)
        }
        .padding()
        .background(Color.black.opacity(0.8))
      }
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
      .overlay(alignment: .trailing) {
        if let delta, delta > 0 {
          Text("+\(delta)")
            .font(.headline.bold())
            .foregroundStyle(.yellow)
            .offset(x: 40, y: animateDelta ? -24 : 0)
            .opacity(animateDelta ? 0 : 1)
        }
      }
      .onChange(of: cards.sum()) { oldSum, newSum in
        let diff = newSum - oldSum
        triggerDeltaAnimation(diff)
      }
  }

  private func triggerDeltaAnimation(_ amount: Int) {
    // Reset state in case points are scored back-to-back
    delta = amount
    animateDelta = false

    withAnimation(.easeOut(duration: PeggingView.animationDuration)) {
      animateDelta = true
    }

    // Clean up after the animation finishes
    Task {
      try? await Task.sleep(for: .seconds(PeggingView.animationDuration))
      if delta == amount {
        delta = nil
        animateDelta = false
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
