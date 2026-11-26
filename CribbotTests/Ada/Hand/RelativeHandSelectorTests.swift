import Testing

@testable import Cribbot

struct RelativeHandSelectorTests {

  @Test func avoidsTossingFive() async throws {
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

  @Test func avoidsTossingConsecutive() async throws {
    let dealt = [
      Card(.three, .clubs), Card(.eight, .spades), Card(.seven, .hearts), Card(.six, .diamonds),
      Card(.jack, .diamonds), Card(.queen, .clubs),
    ]

    let expectedToss = [Card(.three, .clubs), Card(.queen, .clubs)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: false)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

  @Test func toughCall() async throws {
    let dealt = [
      Card(.two, .clubs), Card(.jack, .clubs), Card(.eight, .hearts), Card(.queen, .clubs),
      Card(.eight, .diamonds), Card(.four, .clubs),
    ]

    // this is one that I do not agree with. passing a pair to the opponent's crib is
    // dangerous because the opponent is prone to tossing cards that will compound the
    // points. I suspect that the selector does not pick up on this because it treats
    // the all opponent's tosses as equally likely instead of assuming they are
    // intelligent
    let expectedToss = [Card(.eight, .hearts), Card(.eight, .diamonds)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: false)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

  @Test func negativeExpectedValue() async throws {
    let dealt = [
      Card(.six, .diamonds), Card(.four, .hearts), Card(.three, .clubs), Card(.seven, .spades),
      Card(.queen, .hearts), Card(.ten, .hearts),
    ]

    // this is one that I do not agree with. passing a pair to the opponent's crib is
    // dangerous because the opponent is prone to tossing cards that will compound the
    // points. I suspect that the selector does not pick up on this because it treats
    // the all opponent's tosses as equally likely instead of assuming they are
    // intelligent
    let expectedToss = [Card(.queen, .hearts), Card(.ten, .hearts)]
    let actualToss = await RelativeHandSelector().toss(cards: dealt, ownsCrib: false)

    #expect(
      expectedToss == actualToss,
      "Failed to focus on dangerous crib for RelativeHandSelector")
  }

}
