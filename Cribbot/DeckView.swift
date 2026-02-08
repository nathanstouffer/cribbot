import SwiftUI

final class SelectionManager: ObservableObject {
    @Published private(set) var selected: Set<Card> = []

    /// Optional validator: return true to allow toggling/selecting the card
    var validate: (Set<Card>, Card) -> Bool = { _, _ in true }

    func isSelected(_ card: Card) -> Bool {
        selected.contains(card)
    }

    func toggle(_ card: Card) {
        if isSelected(card) {
            selected.remove(card)
        } else {
            // ask validator whether the new selection is allowed
            if validate(selected, card) {
                selected.insert(card)
            }
        }
    }

    func select(_ cards: [Card]) {
        for card in cards where validate(selected, card) {
            selected.insert(card)
        }
    }

    func deselect(_ card: Card) {
        selected.remove(card)
    }
}

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

    @StateObject private var selectionManager = SelectionManager()

    init() {
        // Example validator: allow up to 6 cards selected (common hand size in some flows)
        selectionManager.validate = { current, card in
            current.contains(card) || current.count < 6
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(deck.indices, id: \.self) { index in
                    let card = deck[index]
                    CardView(card: card,
                             isSelected: selectionManager.isSelected(card),
                             onToggle: { selectionManager.toggle(card) })
                }
            }
            .padding()
        }
    }
}

#Preview {
    DeckView()
}
