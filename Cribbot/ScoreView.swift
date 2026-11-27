import SwiftUI

struct ScoreView: View {

  var score: Int

  @State private var delta: Int?
  @State private var animateDelta = false

  private static let animationDuration = 3.0

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
      .contentTransition(.numericText(value: Double(score)))
      .overlay(alignment: .trailing) {
        if let delta, delta > 0 {
          Text("+\(delta)")
            .font(.headline.bold())
            .foregroundStyle(.yellow)
            .offset(x: 40, y: animateDelta ? -24 : 0)
            .opacity(animateDelta ? 0 : 1)
        }
      }
      .onChange(of: score) { oldScore, newScore in
        let diff = newScore - oldScore
        triggerDeltaAnimation(diff)
      }
  }

  private func triggerDeltaAnimation(_ amount: Int) {
    // Reset state in case points are scored back-to-back
    delta = amount
    animateDelta = false

    withAnimation(.easeOut(duration: ScoreView.animationDuration)) {
      animateDelta = true
    }

    // Clean up after the animation finishes
    Task {
      try? await Task.sleep(for: .seconds(ScoreView.animationDuration))
      if delta == amount {
        delta = nil
        animateDelta = false
      }
    }
  }
}
