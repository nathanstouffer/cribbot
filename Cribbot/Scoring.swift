func score(hand: Array<Card>, flip: Card, isCrib: Bool) -> Int {
  var allCards = hand
  allCards.append(flip)

  var score = 0
  score += scoreFromPairs(cards: allCards)
  score += scoreFromFifteens(cards: allCards)
  score += scoreFromRuns(cards: allCards)
  score += scoreFromFifteens(cards: cards, flip: flip, isCrib: isCrib)
  score += scoreFromNobs(cards, flip)
  return score
}

func scoreFromPairs(cards: Array<Card>) -> Int {
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

func scoreFromFifteens(cards: Array<Card>) -> Int {
  
}

func scoreFromRuns(cards: Array<Card>) -> Int {
  
}

func scoreFromFlush(cards: Array<Card>, flip: Card, isCrib: Bool) -> Int {
  
}

func scoreFromNobs(hand: Array<Card>, flip: Card) -> Int {
  for card in hand {
    if card.rank == Card.Rank.jack && card.suit == flip.suit {
      return 1
    }
  }
  return 0
}
