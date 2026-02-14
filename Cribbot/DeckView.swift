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

    // Deck model
    @State private var deckModel: Deck = Deck(shuffled: false)
    @State private var playerHands: [[Card]] = Array(repeating: [], count: 2)
    private let playersCount: Int = 2

    @StateObject private var selectionManager = SelectionManager()

    private var deckBack: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(LinearGradient(colors: [.red, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(0.75)
                .frame(width: 80, height: 120)
                .shadow(radius: 4)
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Opponent (facedown)
            VStack(alignment: .center, spacing: 6) {
                Text("Opponent")
                    .font(.headline)
                    .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(playerHands.indices.contains(0) ? playerHands[0].indices : [].indices, id: \.self) { _ in
                            deckBack
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()

            // Deck and controls
            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    deckBack
                        .overlay(Text("\(deckModel.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
                    Text("Remaining: \(deckModel.count)")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
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

                        // Select the user's hand (player 1)
                        if playerHands.indices.contains(1) {
                            selectionManager.select(playerHands[1])
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        deckModel = Deck(shuffled: false)
                        for i in 0..<playersCount { playerHands[i].removeAll() }
                        selectionManager.clear()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            // User hand (selectable)
            VStack(alignment: .center, spacing: 6) {
                Text("You")
                    .font(.headline)
                    .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(playerHands.indices.contains(1) ? playerHands[1].indices : [].indices, id: \.self) { cardIdx in
                            let card = playerHands[1][cardIdx]
                            CardView(card: card,
                                     isSelected: selectionManager.isSelected(card),
                                     onToggle: { selectionManager.toggle(card) })
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .onAppear {
            // initialize player hands storage
            playerHands = Array(repeating: [], count: playersCount)
            // default validator: allow selecting up to 6 cards
            selectionManager.validate = { current, card in
                current.contains(card) || current.count < 6
            }
        }
    }
}

#Preview {
    DeckView()
}

