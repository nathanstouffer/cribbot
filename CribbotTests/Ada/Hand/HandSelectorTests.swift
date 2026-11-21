import Testing

@testable import Cribbot

struct HandSelectorTests {

  @Test func allPossiblePairsTests() throws {
    let dealt = [
      Card(.ace, .clubs), Card(.jack, .spades), Card(.ten, .hearts), Card(.two, .diamonds),
      Card(.eight, .diamonds), Card(.four, .clubs),
    ]

    let expected = [
      [dealt[0], dealt[1]],
      [dealt[0], dealt[2]],
      [dealt[0], dealt[3]],
      [dealt[0], dealt[4]],
      [dealt[0], dealt[5]],

      [dealt[1], dealt[2]],
      [dealt[1], dealt[3]],
      [dealt[1], dealt[4]],
      [dealt[1], dealt[5]],

      [dealt[2], dealt[3]],
      [dealt[2], dealt[4]],
      [dealt[2], dealt[5]],

      [dealt[3], dealt[4]],
      [dealt[3], dealt[5]],

      [dealt[4], dealt[5]],
    ]

    #expect(
      expected == dealt.allPairs(),
      "Failed to identify all possible pairs from [Card]")
  }

}
