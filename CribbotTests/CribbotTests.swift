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

    tests.append(
      ScoreTest(
        hand: [
          Card(.jack, .clubs), Card(.five, .diamonds), Card(.five, .hearts), Card(.five, .spades),
        ],
        flip: Card(.five, .clubs),
        isCrib: false, score: 29)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.four, .clubs), Card(.six, .diamonds), Card(.five, .hearts), Card(.four, .spades),
        ],
        flip: Card(.five, .diamonds),
        isCrib: true, score: 24)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.nine, .clubs), Card(.eight, .diamonds), Card(.seven, .hearts),
          Card(.seven, .spades),
        ],
        flip: Card(.eight, .hearts),
        isCrib: true, score: 24)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.seven, .clubs), Card(.seven, .diamonds), Card(.seven, .hearts),
          Card(.seven, .spades),
        ],
        flip: Card(.ace, .hearts),
        isCrib: true, score: 24)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ace, .clubs), Card(.four, .clubs), Card(.ten, .clubs), Card(.jack, .clubs),
        ],
        flip: Card(.ace, .hearts),
        isCrib: false, score: 14)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ace, .clubs), Card(.four, .clubs), Card(.ten, .clubs), Card(.jack, .clubs),
        ],
        flip: Card(.ace, .hearts),
        isCrib: true, score: 10)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ten, .clubs), Card(.four, .clubs), Card(.ace, .clubs), Card(.jack, .clubs),
        ],
        flip: Card(.queen, .clubs),
        isCrib: false, score: 15)
    )

    tests.append(
      ScoreTest(
        hand: [
          Card(.ten, .clubs), Card(.four, .clubs), Card(.ace, .clubs), Card(.jack, .clubs),
        ],
        flip: Card(.queen, .clubs),
        isCrib: true, score: 15)
    )

    for i in 0..<tests.count {
      let test = tests[i]
      let score = score(hand: test.hand, flip: test.flip, isCrib: test.isCrib)
      #expect(test.score == score, "Failed test index \(i)")
    }
  }

}
