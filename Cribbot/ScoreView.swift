import SwiftUI

struct ScoreView: View {

  var adaScore: Int
  var bobScore: Int

  var body: some View {
    HStack {
      Spacer()
      score(text: "Opponent: \(adaScore)")
      Spacer()
      score(text: "You: \(bobScore)")
      Spacer()
    }
  }

  private func score(text: String) -> some View {
    Text(text)
      .foregroundStyle(.white)
      .font(.title2)
  }
}
