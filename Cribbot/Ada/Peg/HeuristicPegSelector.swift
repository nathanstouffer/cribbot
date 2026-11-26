struct HeuristicPegSelector: PegSelector {

  func lay(played: [Card], available: [Card]) -> Card? {
    let options = valid(played: played, available: available)
    if options.isEmpty {
      return nil
    } else {
      var best = LayCandidate(lay: options[0], score: -1000.0)
      for option in options {
        let candidate = evaluate(played: played, playing: option)
        if candidate.score > best.score {
          best = candidate
        } else if candidate.score == best.score {
          if candidate.lay.peggingValue > best.lay.peggingValue {
            best = candidate
          }
        }
      }
      return best.lay
    }
  }

  func evaluate(played: [Card], playing: Card) -> LayCandidate {
    var score = Double(peg(played: played, playing: playing))
    let stack = played + [playing]
    if stack.sum() == 5 || stack.sum() == 21 {
      score -= 1.5
    }
    return LayCandidate(lay: playing, score: score)
  }

}
