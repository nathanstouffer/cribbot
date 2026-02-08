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
    @State private var playerHands: [[Card]] = Array(repeating: [], count: 2)
    @State private var playersCount: Int = 2

    @StateObject private var selectionManager = SelectionManager()

    init() {
        selectionManager.validate = { current, card in
            current.contains(card) || current.count < 6
        }
    }

    private var deckBack: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 120)
                .shadow(radius: 4)
            Text("🂠")
                .font(.largeTitle)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("Deal") {
                    // Shuffle whole deck and deal 6 to each player in round-robin
                    deckModel.shuffle()
                    // clear previous hands and selection
                    for i in 0..<playersCount { playerHands[i].removeAll() }
                    selectionManager.clear()

                    for _ in 0..<6 {
                        for playerIdx in 0..<playersCount {
                            if let card = deckModel.deal(1)?.first {
                                playerHands[playerIdx].append(card)
                            }
                        }
                    }

                    // Optionally select the current player's hand (player 0)
                    selectionManager.select(playerHands.first ?? [])
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    deckModel = Deck(shuffled: false)
                    for i in 0..<playersCount { playerHands[i].removeAll() }
                    selectionManager.clear()
                }

                Spacer()

                HStack(spacing: 8) {
                    deckBack
                        .overlay(Text("\(deckModel.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
                    Text("Remaining: \(deckModel.count)")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)

            // Player hands
            ForEach(0..<playersCount, id: \.self) { idx in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Player \(idx + 1)")
                        .font(.headline)
                        .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(playerHands[idx].indices, id: \.self) { cardIdx in
                                let card = playerHands[idx][cardIdx]
                                CardView(card: card,
                                         isSelected: selectionManager.isSelected(card),
                                         onToggle: { selectionManager.toggle(card) })
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()
        }
        .onAppear {
            // initialize player hands storage
            playerHands = Array(repeating: [], count: playersCount)
        }
    }
}

#Preview {
    DeckView()
}
