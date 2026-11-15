import Testing

@testable import Cribbot

struct GameTests {

  @Test func playerOwnerEquality() throws {
    #expect(Game.Player.ada == CribbageCard.Owner.ada, "Failed Player.ada == Owner.ada")
    #expect(Game.Player.bob == CribbageCard.Owner.bob, "Failed Player.bob == Owner.bob")

    #expect(CribbageCard.Owner.ada == Game.Player.ada, "Failed Owner.ada == Player.ada")
    #expect(CribbageCard.Owner.bob == Game.Player.bob, "Failed Owner.bob == Player.bob")

    #expect(Game.Player.ada != CribbageCard.Owner.bob, "Failed Player.ada != Owner.bob")
    #expect(Game.Player.bob != CribbageCard.Owner.ada, "Failed Player.bob != Owner.ada")
    
    #expect(CribbageCard.Owner.ada != Game.Player.bob, "Failed Owner.ada != Player.bobgs
    ")
    #expect(CribbageCard.Owner.bob != Game.Player.ada, "Failed Owner.bob != Player.ada")
  }

}
