import Testing

@testable import Cribbot

struct RetainedHandSelectorTests {

  @Test func isWillingToThrowPoints() throws {
    let dealt = [
      Card(.six, .clubs), Card(.eight, .spades), Card(.seven, .hearts), Card(.seven, .diamonds),
      Card(.five, .diamonds), Card(.five, .clubs),
    ]

    let expectedToss = [Card(.five, .diamonds), Card(.five, .clubs)]

    #expect(
      expectedToss == RetainedHandSelector().toss(cards: dealt),
      "Failed to focus on retained hand for RandomHandSelector")
  }
  
  @Test func detectsFlush() throws {
    let dealt = [
      Card(.two, .clubs), Card(.six, .clubs), Card(.ten, .clubs), Card(.king, .diamonds),
      Card(.queen, .spades), Card(.four, .clubs),
    ]

    let expectedToss = [Card(.king, .diamonds), Card(.queen, .spades)]

    #expect(
      expectedToss == RetainedHandSelector().toss(cards: dealt),
      "Failed to detect flush for RandomHandSelector")
  }
  
  @Test func detectsDoubleRun() throws {
    let dealt = [
      Card(.six, .clubs), Card(.five, .hearts), Card(.three, .hearts), Card(.six, .diamonds),
      Card(.queen, .clubs), Card(.seven, .diamonds),
    ]

    let expectedToss = [Card(.three, .hearts), Card(.queen, .clubs)]

    #expect(
      expectedToss == RetainedHandSelector().toss(cards: dealt),
      "Failed to detect flush for RandomHandSelector")
  }

}
