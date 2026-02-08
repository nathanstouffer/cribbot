import SwiftUI

struct DeckView: View {

    // 4 columns works nicely for cards this size
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Full deck
    private let deck: [Card] = {
        let values: [Card.Value] = [
            .ace, .two, .three, .four, .five, .six,
            .seven, .eight, .nine, .ten,
            .jack, .queen, .king
        ]

        let suits: [Card.Suit] = [
            .spades, .hearts, .clubs, .diamonds
        ]

        return suits.flatMap { suit in
            values.map { value in
                Card(value: value, suit: suit)
            }
        }
    }()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(deck.indices, id: \.self) { index in
                    CardView(card: deck[index])
                }
            }
            .padding()
        }
    }
}

#Preview {
    DeckView()
}
