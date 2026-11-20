import Testing

@testable import Cribbot

struct RelativeHandSelectorTests {

  @Test func avoidsThrowingFive() throws {
    let dealt = [
      Card(.eight, .clubs), Card(.three, .spades), Card(.three, .hearts), Card(.five, .diamonds),
      Card(.ace, .diamonds), Card(.nine, .clubs),
    ]

    let expectedToss = [Card(.eight, .clubs), Card(.ace, .diamonds)]

    #expect(
      expectedToss == RelativeHandSelector().toss(cards: dealt, ownsCrib: false),
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

}
