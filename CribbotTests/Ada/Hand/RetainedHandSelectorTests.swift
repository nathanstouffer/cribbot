import Testing

@testable import Cribbot

struct RetainedHandSelectorTests {

  @Test func focusesOnRetained() throws {
    let dealt = [
      Card(.six, .clubs), Card(.eight, .spades), Card(.seven, .hearts), Card(.seven, .diamonds),
      Card(.five, .diamonds), Card(.five, .clubs),
    ]

    let expectedToss = [Card(.five, .diamonds), Card(.five, .clubs)]

    #expect(
      expectedToss == RetainedHandSelector().toss(cards: dealt),
      "Failed to focus on retained hand for RandomHandSelector")
  }

}
