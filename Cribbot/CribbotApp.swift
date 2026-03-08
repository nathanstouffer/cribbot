import SwiftUI

@main
struct CribbotApp: App {

  @StateObject var game = GameViewModel()

  var body: some Scene {
    WindowGroup {
      GameView(game)
    }
  }
}
