import SwiftUI

struct ResultView: View {

  let winner: Game.Player

  var body: some View {
    ZStack {
      text.foregroundStyle(.white)
    }
    .padding()
    .background(Color.black.opacity(0.8))
  }
  
  var text: some View {
    if winner == .ada {
      Text("You have lost")
    } else if winner == .bob {
      Text("You have won!")
    } else {
      Text("Error")
    }
  }

}

#Preview {
  VStack {
    Spacer()
    ResultView(winner: .ada)
    Spacer()
    ResultView(winner: .bob)
    Spacer()
  }
}
