import Foundation

struct Score {
    var humanPoints: Int
    var computerPoints: Int
}

enum PlayerType {
    case human
    case computer
}

class GameViewModel: ObservableObject {

    @Published var score: Score = .init(humanPoints: 0, computerPoints: 0)

    var humanScore: Int {
        score.humanPoints
    }

    func increaseScore(for player: PlayerType, by points: Int) {
        switch player {
        case .human:
            score.humanPoints += points
        case .computer:
            score.computerPoints += points
        }
    }

    // Computer state
    @Published var computer = Player()
    @Published var computerStaging: HandStaging = .preThrow([])


    // Human stage
    @Published var human = Player()
    @Published var humanStaging: HandStaging = .preThrow([])


    // Crib state
    @Published private(set) var cribOwner: CribOwner = CribOwner.allCases.randomElement()!
    @Published private(set) var crib: [Card] = []
    @Published private(set) var isCribLocked = false


    // Deck state
    @Published private(set) var deck = Card.fullDeckByRank
    @Published private(set) var flippedCard: Card?

    @Published private(set) var stagedForCrib: [Card] = []
    @Published private(set) var stagedForLay: Card?
    @Published private(set) var stage = HandStage.initial


    // MARK: - Intent functions

    func resetDeck() {
        deck = Card.fullDeckByRank
        flippedCard = nil
        crib = []
        isCribLocked = false
        human.hand.reset()
        computer.hand.reset()
        stagedForCrib = []
        stagedForLay = nil
        stage = .initial
        cribOwner.toggle()
    }

    func shuffleAndDeal() {
        resetDeck()
        deck.shuffle()
        var first = [Card]()
        var second = [Card]()
        for _ in 0..<6 {
            // TODO (stouff) adapt this to who is going first
            first.append(deck[0])
            deck.removeFirst()
            second.append(deck[0])
            deck.removeFirst()
        }
        if cribOwner == .computer {
            computer.hand = first
            human.hand = second
        } else {
            human.hand = first
            computer.hand = second
        }
        stage = .selectingCrib
    }

    func flip() {
        flippedCard = deck[0]
        deck.removeFirst()
    }

    func stageForCrib(_ card: Card) {
        if !stagedForCrib.contains(card) {
            stagedForCrib.insert(card, at: 0)
            if stagedForCrib.count > 2 {
                stagedForCrib.removeLast()
            }
        }
    }

    func unstageForCrib(_ card: Card) {
        stagedForCrib.removeAll(where: { $0.id == card.id })
    }

    func isStagedForCrib(_ card: Card) -> Bool {
        return stagedForCrib.contains(card)
    }

    func throwToCrib() {
        if stagedForCrib.count == 2 {
            crib.append(stagedForCrib[0])
            crib.append(stagedForCrib[1])
            human.hand.removeAll(where: { $0 == stagedForCrib[0] })
            human.hand.removeAll(where: { $0 == stagedForCrib[1] })
            stagedForCrib = []
            crib.append(computer.hand[0])
            crib.append(computer.hand[1])
            computer.hand.removeFirst()
            computer.hand.removeFirst()
            flip()
            isCribLocked = true
            stage = .scoringHands
        }
    }

    func stageForLay(_ card: Card) {
        stagedForLay = card
    }

    func unstageForLay(_ card: Card) {
        stagedForLay = nil
    }

    func isStagedForLay(_ card: Card) -> Bool {
        if let staged = stagedForLay {
            return card == staged
        } else {
            return false
        }
    }

    func lay(_ card: Card) {
        // TODO: implement this
    }

    func scoreHands() {
        if let flippedCard = flippedCard {
            computer.score += score(hand: computer.hand, flip: flippedCard, isCrib: false)
            human.score += score(hand: human.hand, flip: flippedCard, isCrib: false)
        }
    }

}

extension [Card] {
    mutating func reset() {
        self = []
    }
}
