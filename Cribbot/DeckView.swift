import SwiftUI

final class SelectionManager: ObservableObject {
    @Published private(set) var selected: [Card] = []

    /// Optional validator: return true to allow toggling/selecting the card
    var validate: ([Card], Card) -> Bool = { _, _ in true }

    /// Maximum number of selected cards to keep; when exceeded, oldest is evicted.
    var maxSelected: Int = 2

    func isSelected(_ card: Card) -> Bool {
        selected.contains(card)
    }

    func toggle(_ card: Card) {
        if let idx = selected.firstIndex(of: card) {
            selected.remove(at: idx)
        } else {
            if validate(selected, card) {
                if selected.count >= maxSelected {
                    selected.removeFirst()
                }
                selected.append(card)
            }
        }
    }

    func select(_ cards: [Card]) {
        for card in cards where validate(selected, card) {
            if !selected.contains(card) {
                if selected.count >= maxSelected {
                    selected.removeFirst()
                }
                selected.append(card)
            }
        }
    }

    func deselect(_ card: Card) {
        if let idx = selected.firstIndex(of: card) {
            selected.remove(at: idx)
        }
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
    @State private var crib: [Card] = []
    @State private var cribLocked: Bool = false

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
            VStack(alignment: .center, spacing: 10) {
                Text("Opponent")
                    .font(.headline)
                    .padding(.leading)
                // opponent layout matches player: grid when 6, row when 4, otherwise horizontal scroll
                let oppCards = playerHands.indices.contains(0) ? playerHands[0] : []

                if oppCards.count == 6 {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 6), count: 3), spacing: 6) {
                        ForEach(oppCards.indices, id: \.self) { _ in
                            deckBack
                        }
                    }
                    .padding(.horizontal)
                } else if oppCards.count == 4 {
                    HStack(spacing: 8) {
                        ForEach(oppCards.indices, id: \.self) { _ in
                            deckBack
                        }
                    }
                    .padding(.horizontal)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(oppCards.indices, id: \.self) { _ in
                                deckBack
                            }
                        }
                        .padding(.horizontal)
                    }
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

                        // reset crib and selection state
                        crib.removeAll()
                        cribLocked = false
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        deckModel = Deck(shuffled: false)
                        for i in 0..<playersCount { playerHands[i].removeAll() }
                        selectionManager.clear()
                        crib.removeAll()
                        cribLocked = false
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            
            HStack(spacing: 8) {
                ForEach(crib.indices, id: \.self) { i in
                    CardView(card: crib[i], isSelected: false, onToggle: nil)
                }
            }
            
            Spacer()
            
            // User hand (selectable)
            VStack(alignment: .center, spacing: 10) {
                Button("Confirm Crib") {
                    // only proceed if exactly two selected
                    let selected = Array(selectionManager.selected)
                    guard selected.count == 2 else { return }

                    // remove selected from user's hand
                    for card in selected {
                        if let idx = playerHands[1].firstIndex(of: card) {
                            playerHands[1].remove(at: idx)
                        }
                    }

                    // add to crib
                    crib.append(contentsOf: selected)

                    // lock further selection from user
                    cribLocked = true

                    // opponent (player 0) randomly selects two cards to throw to crib
                    if playerHands.indices.contains(0) {
                        let opponentPool = playerHands[0]
                        let toThrow = Array(opponentPool.shuffled().prefix(2))
                        for card in toThrow {
                            if let idx = playerHands[0].firstIndex(of: card) {
                                playerHands[0].remove(at: idx)
                                crib.append(card)
                            }
                        }
                    }

                    // clear selection manager (user selections removed)
                    selectionManager.clear()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectionManager.selected.count != 2 || cribLocked)
                
                Text("You")
                    .font(.headline)
                    .padding(.leading)

                // layout: grid when 6 cards, single row when 4 (otherwise horizontal scroll)
                let userCards = playerHands.indices.contains(1) ? playerHands[1] : []

                if userCards.count == 6 {
                    // 2 rows x 3 columns grid (tighter spacing)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 6), count: 3), spacing: 6) {
                        ForEach(userCards.indices, id: \.self) { idx in
                            let card = userCards[idx]
                            CardView(card: card,
                                     isSelected: selectionManager.isSelected(card),
                                     onToggle: { if !cribLocked { selectionManager.toggle(card) } })
                        }
                    }
                    .padding(.horizontal)
                } else if userCards.count == 4 {
                    HStack(spacing: 8) {
                        ForEach(userCards.indices, id: \.self) { idx in
                            let card = userCards[idx]
                            CardView(card: card,
                                     isSelected: selectionManager.isSelected(card),
                                     onToggle: { if !cribLocked { selectionManager.toggle(card) } })
                        }
                    }
                    .padding(.horizontal)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(userCards.indices, id: \.self) { idx in
                                let card = userCards[idx]
                                CardView(card: card,
                                         isSelected: selectionManager.isSelected(card),
                                         onToggle: { if !cribLocked { selectionManager.toggle(card) } })
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
            // allow any selection; SelectionManager will keep the most-recent two
            selectionManager.validate = { _, _ in true }
        }
    }
}

#Preview {
    DeckView()
}

