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
    for j in i..<cards.count {
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
  return 0
}

func scoreFromRuns(cards: [Card]) -> Int {
  return 0
}

func scoreFromFlush(cards: [Card], flip: Card, isCrib: Bool) -> Int {
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
