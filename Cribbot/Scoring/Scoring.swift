extension [Card] {

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

}
