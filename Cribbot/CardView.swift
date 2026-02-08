//
//  CardView.swift
//  cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

struct Card {
    
    enum Value {
        case ace, two, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king
        
        var display: String {
            switch self {
                case .ace:   return "A"
                case .two:   return "2"
                case .three: return "3"
                case .four:  return "4"
                case .five:  return "5"
                case .six:   return "6"
                case .seven: return "7"
                case .eight: return "8"
                case .nine:  return "9"
                case .ten:   return "10"
                case .jack:  return "J"
                case .queen: return "Q"
                case .king:  return "K"
                }
            }
        }
    
    enum Suit {
        case spades
        case hearts
        case clubs
        case diamonds
        
        var symbol: String {
            switch self {
            case .spades:   return "♠️"
            case .hearts:   return "❤️"
            case .clubs:    return "♣️"
            case .diamonds: return "♦️"
            }
        }

        var color: Color {
            switch self {
            case .hearts, .diamonds: return .red
            case .spades, .clubs:    return .black
            }
        }
    }
    
    var value: Value
    var suit: Suit
}

struct CardView: View {
    
    var card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(Color.white)
                .frame(width: 80, height: 120)
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 10)
            Text("\(card.value.display)\(card.suit.symbol)")
                .bold()
                .font(.title)
                .foregroundStyle(card.suit.color)
        }
    }
}

#Preview {
    CardView(card: Card(value: .ace, suit: .clubs))
}
