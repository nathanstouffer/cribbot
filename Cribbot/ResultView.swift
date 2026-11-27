import SwiftUI

struct ResultView: View {

  let winner: Game.Player

  var body: some View {
    HStack {
      Spacer()
      text
        .foregroundStyle(.white)
        .font(.title)
      Spacer()
    }
    .padding(.vertical, 125)
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
