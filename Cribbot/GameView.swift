import SwiftUI

struct GameView: View {

  @ObservedObject private var game: GameViewModel

  @Namespace private var animationNamespace

  init(_ game: GameViewModel) {
    self.game = game
  }

  var body: some View {
    ZStack {
      background
      VStack {
        adaHand
        Spacer()
        ScoreView(score: game.adaScore).padding(20)
        ZStack {
          TrayView(game, animationNamespace: animationNamespace)
          PeggingView(game, cards: game.peggingStack, animationNamespace: animationNamespace)
        }
        buttons
        ScoreView(score: game.bobScore)
        Spacer()
        bobHand
      }
    }
  }

  private var adaHand: some View {
    hand(
      cards: game.isPegging ? game.adaHand.unlayed : game.adaHand.cards,
      crib: game.showAdaCrib ? game.crib : [], isFaceUp: game.showAdaCards)
  }

  private var bobHand: some View {
    hand(
      cards: game.isPegging ? game.bobHand.unlayed : game.bobHand.cards,
      crib: game.showBobCrib ? game.crib : [], isFaceUp: true)
  }

  private var buttons: some View {
    HStack {
      Spacer()
      dealButton
      Spacer()
      tossButton
      Spacer()
      layButton
      Spacer()
      goButton
      Spacer()
      nextButton
      Spacer()
    }
    .padding(20)
  }

  private var dealButton: some View {
    Button("Deal") {
      withAnimation {
        game.startNewHand()
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canDeal)
  }

  private var tossButton: some View {
    Button("Toss") {
      if game.canToss {
        withAnimation {
          game.toss(game.staged[0], game.staged[1])
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canToss)
  }

  private var layButton: some View {
    Button("Lay") {
      if game.canLay {
        withAnimation {
          game.lay(game.staged[0])
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canLay)
  }

  private var goButton: some View {
    Button("Go") {
      if game.canGo {
        withAnimation {
          game.go()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canGo)
  }

  private var scoreButton: some View {
    Button("Score") {
      if game.canScore {
        withAnimation {
          game.scoreNextHand()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!game.canScore)
  }

  private var nextButton: some View {
    Button("Next") {
      withAnimation {
        if game.canScore {
          game.scoreNextHand()
        } else if game.canEndHand {
          game.endHand()
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .disabled(!(game.canScore || game.canEndHand))
  }

  private var background: some View {
    Rectangle()
      .fill(.green)
      .ignoresSafeArea()
  }

  // MARK: - hand view
  private func hand(cards: [Card], crib: [Card], isFaceUp: Bool) -> some View {
    ZStack {
      HandView(
        game: game, cards: cards, isFaceUp: isFaceUp,
        animationNamespace: animationNamespace)
      HandView(
        game: game, cards: crib, isFaceUp: isFaceUp,
        animationNamespace: animationNamespace)
    }
  }
}

#Preview {
  GameView(GameViewModel())
}
