struct RandomPegSelector: PegSelector {

  func lay(played: [Card], available: [Card]) -> Card? {
    let sum = played.sum()
    let valid = available.filter { sum + $0.peggingValue <= 31 }
    if valid.isEmpty {
      return nil
    } else {
      return valid.randomElement()
    }
  }

}
