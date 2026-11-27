import SwiftUI

struct PlayerView: View {
  @ObservedObject private var game: GameViewModel

  let hand: Game.Hand
  let crib: [Card]
  let isFaceUp: Bool
  let allowStage: Bool
  private let animationNamespace: Namespace.ID

  init(
    game: GameViewModel, hand: Game.Hand, crib: [Card], isFaceUp: Bool, allowStage: Bool,
    animationNamespace: Namespace.ID
  ) {
    self.game = game
    self.hand = hand
    self.crib = crib
    self.isFaceUp = isFaceUp
    self.allowStage = allowStage
    self.animationNamespace = animationNamespace
  }

  var body: some View {
    ZStack {
      if game.isPegging {
        peggingDisplay
      } else {
        handDisplay
      }
      cribDisplay
    }
  }
  
  var peggingDisplay: some View {
    HStack {
      layed
      HandView(
        game: game, cards: hand.unlayed, isFaceUp: isFaceUp, allowStage: allowStage,
        animationNamespace: animationNamespace)
    }
  }
  
  var layed: some View {
    ZStack {
      ForEach(hand.layed.minus(game.peggingStack)) { card in
        CardView.back(shadowRadius: 0)
          .matchedGeometryEffect(id: card.id, in: animationNamespace)
      }
    }
  }
  
  var handDisplay: some View {
    HandView(
      game: game, cards: hand.cards, isFaceUp: isFaceUp, allowStage: allowStage,
      animationNamespace: animationNamespace)
  }
  
  var cribDisplay: some View {
    HandView(
      game: game, cards: crib, isFaceUp: isFaceUp, allowStage: false,
      animationNamespace: animationNamespace)
  }
}
