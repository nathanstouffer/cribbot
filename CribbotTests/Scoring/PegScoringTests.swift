import Testing

@testable import Cribbot

struct PegScoringTests {

  struct ScoreTest {
    let played: [Card]
    let playing: Card
    let score: Int
  }

  @Test func scores() throws {
    var tests = [ScoreTest]()

    tests.append(
      ScoreTest(
        played: [],
        playing: Card(.two, .diamonds),
        score: 0
      )
    )

    tests.append(
      ScoreTest(
        played: [],
        playing: Card(.five, .diamonds),
        score: 0
      )
    )

    tests.append(
      ScoreTest(
        played: [Card(.five, .clubs)],
        playing: Card(.five, .diamonds),
        score: 2
      )
    )

    tests.append(
      ScoreTest(
        played: [Card(.five, .clubs), Card(.five, .spades)],
        playing: Card(.five, .diamonds),
        score: 8
      )
    )

    tests.append(
      ScoreTest(
        played: [Card(.two, .spades), Card(.ace, .diamonds), Card(.four, .clubs)],
        playing: Card(.three, .diamonds),
        score: 4
      )
    )

    tests.append(
      ScoreTest(
        played: [Card(.ace, .hearts), Card(.ten, .spades), Card(.jack, .hearts)],
        playing: Card(.eight, .diamonds),
        score: 0
      )
    )

    tests.append(
      ScoreTest(
        played: [Card(.ace, .hearts), Card(.ten, .spades), Card(.jack, .hearts)],
        playing: Card(.queen, .diamonds),
        score: 5
      )
    )

    tests.append(
      ScoreTest(
        played: [
          Card(.two, .hearts), Card(.ten, .spades), Card(.king, .hearts), Card(.five, .spades),
          Card(.two, .spades),
        ],
        playing: Card(.two, .diamonds),
        score: 4
      )
    )

    for i in 0..<tests.count {
      let test = tests[i]
      let score = peg(played: test.played, playing: test.playing)
      #expect(test.score == score, "Failed test index \(i)")
    }
  }

}
