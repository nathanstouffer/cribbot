//
//  CardView.swift
//  cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

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

#Preview("Grid of cards") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
            ForEach(Card.fullDeckByValue.indices, id: \.self) {
                CardView(card: Card.fullDeckByValue[$0])
            }
        }
        .padding()
    }
}
