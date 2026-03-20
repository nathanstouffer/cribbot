func score(hand: [Card], flip: Card, isCrib: Bool) -> Int {
  var cards = hand
  cards.append(flip)

  var score = 0
  score += scoreFromPairs(cards: cards)
  score += scoreFromFifteens(cards: cards)
  score += scoreFromRuns(cards: cards)
  score += scoreFromFlush(cards: hand, flip: flip, isCrib: isCrib)
  score += scoreFromNobs(hand: hand, flip: flip)
  return score
}

func scoreFromPairs(cards: [Card]) -> Int {
  var score = 0
  for i in 0..<cards.count {
    for j in i + 1..<cards.count {
      let lhs = cards[i]
      let rhs = cards[j]
      if lhs.rank == rhs.rank {
        score += 2
      }
    }
  }
  return score
}

func scoreFromFifteens(cards: [Card]) -> Int {
  var score = 0
  for subset in cards.powerSet() {
    if subset.sum() == 15 {
      score += 2
    }
  }
  return score
}

func scoreFromRuns(cards: [Card]) -> Int {
  var score = 0
  var threshold: Int?
  for subset in cards.powerSet().filter({ $0.count >= 3 }) {
    if let threshold = threshold {
      if subset.count < threshold {
        return score
      }
    }
    if subset.isRun() {
      score += subset.count
      threshold = subset.count
    }
  }
  return score
}

func scoreFromFlush(cards: [Card], flip: Card, isCrib: Bool) -> Int {
  if cards.allSameSuit() {
    let suit = cards[0].suit
    if suit == flip.suit {
      return 5
    } else if !isCrib {
      return 4
    } else {
      return 0
    }
  }
  return 0
}

func scoreFromNobs(hand: [Card], flip: Card) -> Int {
  for card in hand {
    if card.rank == Card.Rank.jack && card.suit == flip.suit {
      return 1
    }
  }
  return 0
}

extension [Card] {

  func powerSet() -> [[Card]] {
    var result = [[Card]]()
    var current = [Card]()

    func backtrack(start index: Int) {
      // Add the current subset to the results
      result.append(current)

      // Iterate from the current index to the end of the array
      for i in index..<count {
        // 1. Include the current element
        current.append(self[i])
        // 2. Recurse to find subsets with the included element
        backtrack(start: i + 1)
        // 3. Exclude the current element (backtrack) to explore other possibilities
        current.removeLast()
      }
    }

    backtrack(start: 0)

    result.sort(by: { $0.count > $1.count })
    return result
  }

  func sum() -> Int {
    var total = 0
    for card in self {
      total += card.rank.peggingValue
    }
    return total
  }

  func isRun() -> Bool {
    let sorted = self.sorted(by: { $0.rank.runValue < $1.rank.runValue })
    for i in 1..<sorted.count {
      let prev = sorted[i - 1]
      let curr = sorted[i]
      if prev.rank.runValue + 1 != curr.rank.runValue {
        return false
      }
    }
    return true
  }

  func allSameSuit() -> Bool {
    if count <= 1 {
      return true
    }
    let suit = self[0].suit
    for i in 1..<count {
      if suit != self[i].suit {
        return false
      }
    }
    return true
  }

}
