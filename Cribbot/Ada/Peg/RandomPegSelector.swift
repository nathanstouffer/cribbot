struct RandomPegSelector: PegSelector {

  func lay(played: [Card], available: [Card]) -> Card? {
    let sum = played.sum()
    let valid = available.filter { $0.rank.peggingValue + sum <= 31 }
    if valid.isEmpty {
      return nil
    } else {
      return valid.randomElement()
    }
  }

}
