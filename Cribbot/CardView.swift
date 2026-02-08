//
//  CardView.swift
//  cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

struct CardView: View {

    var card: Card
    var isSelected: Bool = false
    var onToggle: (() -> Void)? = nil

    var body: some View {
        Button(action: { onToggle?() }) {
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
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
            )
            .scaleEffect(isSelected ? 1.06 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(card.value.display) of \(String(describing: card.suit))")
    }
}

#Preview("Grid of cards") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
            ForEach(Card.fullDeckByValue.indices, id: \.self) { idx in
                CardView(card: Card.fullDeckByValue[idx], isSelected: false, onToggle: {})
            }
        }
        .padding()
    }
}
