import Testing

@testable import Cribbot

struct RelativeHandSelectorTests {

  @Test func avoidsThrowingFive() async throws {
    let dealt = [
      Card(.eight, .clubs), Card(.three, .spades), Card(.three, .hearts), Card(.five, .diamonds),
      Card(.ace, .diamonds), Card(.nine, .clubs),
    ]

    let expectedToss = [Card(.eight, .clubs), Card(.ace, .diamonds)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: false)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

}
