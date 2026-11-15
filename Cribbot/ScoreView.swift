import SwiftUI

struct ScoreView: View {

  var score: Int

  var body: some View {
    HStack {
      Spacer()
      score(text: "Score: \(score)")
      Spacer()
    }
  }

  private func score(text: String) -> some View {
    Text(text)
      .foregroundStyle(.white)
      .font(.title2)
  }
}
