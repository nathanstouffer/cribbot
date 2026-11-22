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

  @Test func separatesCrib() async throws {
    let dealt = [
      Card(.five, .clubs), Card(.five, .spades), Card(.nine, .clubs), Card(.six, .diamonds),
      Card(.ten, .diamonds), Card(.queen, .clubs),
    ]

    let expectedToss = [Card(.nine, .clubs), Card(.six, .diamonds)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: true)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

  @Test func keepsTigherFifteen() async throws {
    let dealt = [
      Card(.two, .clubs), Card(.eight, .spades), Card(.five, .hearts), Card(.ten, .diamonds),
      Card(.ace, .diamonds), Card(.four, .clubs),
    ]

    let expectedToss = [Card(.two, .clubs), Card(.eight, .spades)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: false)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

}
