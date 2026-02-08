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

    func clear() {
        selected.removeAll()
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

    // Deck model
    @State private var deckModel: Deck = Deck(shuffled: false)
    @State private var dealtHand: [Card] = []

    @StateObject private var selectionManager = SelectionManager()

    init() {
        selectionManager.validate = { current, card in
            current.contains(card) || current.count < 6
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("Deal Hand") {
                    deckModel.shuffle()
                    if let hand = deckModel.deal(6) {
                        dealtHand = hand
                        selectionManager.clear()
                        selectionManager.select(hand)
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Reset Deck") {
                    deckModel = Deck(shuffled: false)
                    dealtHand = []
                    selectionManager.clear()
                }

                Spacer()

                Text("Remaining: \(deckModel.count)")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            // Show dealt hand
            if !dealtHand.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dealtHand.indices, id: \.self) { idx in
                            let card = dealtHand[idx]
                            CardView(card: card,
                                     isSelected: selectionManager.isSelected(card),
                                     onToggle: { selectionManager.toggle(card) })
                        }
                    }
                    .padding(.horizontal)
                }
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(deckModel.cards.indices, id: \.self) { index in
                        let card = deckModel.cards[index]
                        CardView(card: card,
                                 isSelected: selectionManager.isSelected(card),
                                 onToggle: { selectionManager.toggle(card) })
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    DeckView()
}
