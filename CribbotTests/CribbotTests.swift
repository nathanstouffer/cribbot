import Testing

@testable import Cribbot

struct CribbotTests {

  struct ScoreTest {
    let hand: [Card]
    let flip: Card
    let isCrib: Bool
    let score: Int
  }

  @Test func scores() throws {
    var tests = [ScoreTest]()

    tests.append(
      ScoreTest(
        hand: [
          Card(.two, .clubs), Card(.four, .diamonds), Card(.six, .hearts), Card(.eight, .spades),
        ],
        flip: Card(.ten, .clubs),
        isCrib: false, score: 0)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ace, .clubs), Card(.ace, .diamonds), Card(.ace, .hearts), Card(.ace, .spades),
        ],
        flip: Card(.ten, .clubs),
        isCrib: false, score: 12)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ten, .clubs), Card(.ace, .diamonds), Card(.ace, .hearts), Card(.ace, .spades),
        ],
        flip: Card(.ten, .diamonds),
        isCrib: false, score: 8)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ten, .clubs), Card(.jack, .diamonds), Card(.ace, .hearts), Card(.ace, .spades),
        ],
        flip: Card(.ten, .diamonds),
        isCrib: false, score: 5)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ten, .clubs), Card(.ace, .diamonds), Card(.ace, .hearts), Card(.ace, .spades),
        ],
        flip: Card(.ten, .diamonds),
        isCrib: false, score: 8)
    )

    for i in 0..<tests.count {
      let test = tests[i]
      let score = score(hand: test.hand, flip: test.flip, isCrib: test.isCrib)
      #expect(test.score == score, "Failed test index \(i)")
    }
  }

}
