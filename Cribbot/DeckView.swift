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
    private let deck: [Card] = Card.fullDeckByValue

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
