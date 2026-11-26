struct RandomPegSelector: PegSelector {

  func lay(played: [Card], available: [Card]) -> Card? {
    let options = valid(played: played, available: available)
    if options.isEmpty {
      return nil
    } else {
      return options.randomElement()
    }
  }

}
