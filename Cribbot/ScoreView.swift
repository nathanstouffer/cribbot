import SwiftUI

struct ScoreView: View {

  var computer: Player
  var human: Player

  var body: some View {
    HStack {
      Spacer()
      score(text: "Opponent: \(computer.score)")
      Spacer()
      score(text: "You: \(human.score)")
      Spacer()
    }
  }

  private func score(text: String) -> some View {
    Text(text)
      .foregroundStyle(.white)
      .font(.title2)
  }
}
