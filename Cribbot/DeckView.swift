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
                // confirm crib selection button
                    // show crib contents
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(playerHands.indices.contains(1) ? playerHands[1].indices : [].indices, id: \.self) { cardIdx in
                            let card = playerHands[1][cardIdx]
                            CardView(card: card,
                                     isSelected: selectionManager.isSelected(card),
                                     onToggle: { if !cribLocked { selectionManager.toggle(card) } })
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
            // default validator: allow selecting up to 2 cards for crib
            selectionManager.validate = { current, card in
                current.contains(card) || current.count < 2
            }
        }
    }
}

#Preview {
    DeckView()
}

