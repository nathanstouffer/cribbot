import Testing

@testable import Cribbot

struct CribbotTests {

  struct ScoreTest {
    let hand: [Card]
    let flip: Card
    let isCrib: Bool
    let score: Int
  }

  @Test func testScore() throws {
    var tests = Array<ScoreTest>()

    tests.append(
      ScoreTest(
        hand: [Card(rank: .ace, suit: .clubs)], flip: Card(rank: .king, suit: .diamonds),
        isCrib: false, score: 0)
    )

    for i in 0..<tests.count {
      let test = tests[i]
      let score = score(hand: test.hand, flip: test.flip, isCrib: test.isCrib)
      #expect(test.score == score, "Failed test index \(i)")
    }
  }

}
