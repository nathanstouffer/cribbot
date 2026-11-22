func peg(played: [Card], playing: Card) -> Int {
  let candidate = played + [playing]

  var score = 0
  score += pegFromFifteen(cards: candidate)
  score += pegFromThirtyOne(cards: candidate)
  score += pegFromRun(cards: candidate)
  score += pegFromPairs(cards: candidate)
  return score
}

func pegFromFifteen(cards: [Card]) -> Int {
  cards.sum() == 15 ? 2 : 0
}

func pegFromThirtyOne(cards: [Card]) -> Int {
  cards.sum() == 31 ? 2 : 0
}

func pegFromRun(cards: [Card]) -> Int {
  for i in 0..<cards.count {
    let trimmed = Array(cards[i...])
    if trimmed.count >= 3 && trimmed.isRun() {
      return trimmed.count
    }
  }
  return 0
}

func pegFromPairs(cards: [Card]) -> Int {
  for i in 0..<cards.count {
    let trimmed = Array(cards[i...])
    if trimmed.count >= 2 && trimmed.allSameRank() {
      switch trimmed.count {
      case 2: return 2
      case 3: return 6
      case 4: return 12
      default: fatalError("Too many cards of same rank")
      }
    }
  }
  return 0
}

extension [Card] {

  func allSameRank() -> Bool {
    if count > 0 {
      let first = self[0]
      for i in 1..<count {
        if first.rank != self[i].rank {
          return false
        }
      }
    }
    return true
  }

}
