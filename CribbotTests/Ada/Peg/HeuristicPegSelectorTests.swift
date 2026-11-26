import Testing

@testable import Cribbot

struct HeuristicPegSelectorTests {

  struct SelectorTest {
    let played: [Card]
    let available: [Card]
    let expected: Card?
  }

  @Test func scores() throws {
    var tests = [SelectorTest]()

    tests.append(
      SelectorTest(
        played: [],
        available: [Card(.two, .diamonds), Card(.king, .hearts)],
        expected: Card(.king, .hearts)
      )
    )

    tests.append(
      SelectorTest(
        played: [],
        available: [Card(.five, .diamonds), Card(.two, .hearts)],
        expected: Card(.two, .hearts)
      )
    )

    tests.append(
      SelectorTest(
        played: [Card(.six, .spades)],
        available: [Card(.two, .diamonds), Card(.king, .hearts), Card(.nine, .diamonds)],
        expected: Card(.nine, .diamonds)
      )
    )

    tests.append(
      SelectorTest(
        played: [Card(.six, .spades), Card(.eight, .hearts)],
        available: [Card(.two, .diamonds), Card(.seven, .hearts), Card(.nine, .diamonds)],
        expected: Card(.seven, .hearts)
      )
    )

    tests.append(
      SelectorTest(
        played: [Card(.six, .spades), Card(.nine, .hearts)],
        available: [Card(.two, .diamonds), Card(.six, .hearts)],
        expected: Card(.two, .diamonds)
      )
    )

    tests.append(
      SelectorTest(
        played: [Card(.six, .spades), Card(.ten, .clubs), Card(.nine, .hearts)],
        available: [Card(.two, .diamonds), Card(.six, .hearts)],
        expected: Card(.six, .hearts)
      )
    )

    tests.append(
      SelectorTest(
        played: [Card(.six, .spades), Card(.ten, .clubs), Card(.nine, .hearts)],
        available: [Card(.nine, .spades), Card(.eight, .clubs), Card(.jack, .hearts)],
        expected: nil
      )
    )

    for i in 0..<tests.count {
      let test = tests[i]
      let selected = HeuristicPegSelector().lay(played: test.played, available: test.available)
      #expect(test.expected == selected, "Failed test index \(i)")
    }
  }

}
