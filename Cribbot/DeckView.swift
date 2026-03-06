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

struct SlotView<Content: View>: View {
    let text: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white)
                    .frame(width: 93, height: 133)
                content()
            }
            Text(text)
                .foregroundStyle(.secondary)
        }
    }
}

struct DeckView: View {

    // Deck model
    // TODO (stouff) probably put all this state stuff in the model
    @State private var deckModel: Deck = Deck(shuffled: false)
    @State private var playerHands: [[Card]] = Array(repeating: [], count: 2)
    private let playersCount: Int = 2
    @State private var crib: [Card] = []
    @State private var flippedCard: Card? = nil
    @State private var cribLocked: Bool = false

    @StateObject private var selectionManager = SelectionManager()

    // TODO (stouff) this should probably be its own file (or maybe part of CardView?)
    private var deckBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 80, height: 120)
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(colors: [.orange, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 72, height: 112)
                .shadow(radius: 4)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Opponent (facedown)
            VStack(alignment: .center, spacing: 10) {
                // opponent layout matches player: overlapping when 6, row when 4, otherwise horizontal scroll
                let oppCards = playerHands.indices.contains(0) ? playerHands[0] : []
                let cardWidth: CGFloat = 80
                let overlap: CGFloat = 52

                if oppCards.count == 6 {
                    let totalWidth = cardWidth + overlap * CGFloat(max(0, oppCards.count - 1))
                    let mid = CGFloat(oppCards.count - 1) / 2.0
                    HStack {
                        Spacer()
                        ZStack { // centered
                            ForEach(oppCards.indices, id: \.self) { idx in
                                deckBack
                                    .offset(x: (CGFloat(idx) - mid) * overlap)
                                    .zIndex(Double(idx))
                            }
                        }
                        .frame(width: totalWidth, height: 140)
                        Spacer()
                    }
                    .padding(.horizontal)
                } else if oppCards.count == 4 {
                    HStack(spacing: 8) {
                        Spacer()
                        ForEach(oppCards.indices, id: \.self) { _ in
                            deckBack
                        }
                        Spacer()
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
                SlotView(text: "Deck") {
                    VStack(spacing: 8) {
                        deckBack
                            .overlay(Text("\(deckModel.count)").foregroundStyle(.white).bold().offset(x: 0, y: 40))
                    }
                }
                Spacer()
                SlotView(text: "Flip") {
                    if let card = flippedCard {
                        CardView(card: card, isSelected: false, onToggle: nil)
                    } else {
                        EmptyView()
                    }
                }
                Spacer()
                SlotView(text: "Crib") {
                    ForEach(crib.indices, id: \.self) { i in
                        deckBack
                    }
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 100) {
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
                    flippedCard = nil
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    deckModel = Deck(shuffled: false)
                    for i in 0..<playersCount { playerHands[i].removeAll() }
                    selectionManager.clear()
                    crib.removeAll()
                    cribLocked = false
                    flippedCard = nil
                }
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
            
            // User hand (selectable)
            VStack(alignment: .center, spacing: 30) {
                Button("Throw") {
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

                    // flip the top card of the deck
                    flippedCard = deckModel.deal(1)?.first
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectionManager.selected.count != 2 || cribLocked)

                // layout: grid when 6 cards, single row when 4 (otherwise horizontal scroll)
                let userCards = playerHands.indices.contains(1) ? playerHands[1] : []

                    if userCards.count == 6 {
                        // overlapping left-to-right layout for experimentation (centered)
                        let cardWidth: CGFloat = 80
                        let overlap: CGFloat = 52
                        let totalWidth = cardWidth + overlap * CGFloat(max(0, userCards.count - 1))

                        HStack {
                            Spacer()
                            let mid = CGFloat(userCards.count - 1) / 2.0
                            ZStack { // centered
                                ForEach(userCards.indices, id: \.self) { idx in
                                    let card = userCards[idx]
                                    CardView(card: card,
                                             isSelected: selectionManager.isSelected(card),
                                             onToggle: { if !cribLocked { selectionManager.toggle(card) } })
                                    .offset(x: (CGFloat(idx) - mid) * overlap, y: selectionManager.isSelected(card) ? -12 : 0)
                                    .zIndex(Double(idx))
                                }
                            }
                            .frame(width: totalWidth, height: 140)
                            Spacer()
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
