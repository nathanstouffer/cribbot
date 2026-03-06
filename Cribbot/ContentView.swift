import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Rectangle()
        .fill(.green)
        .ignoresSafeArea()
      DeckView()
    }
  }
}

#Preview {
  ContentView()
}
