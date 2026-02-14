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
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                indexes
                pips
            }
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
            )
            .frame(width: 80, height: 120)
            .scaleEffect(isSelected ? 1.06 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(card.value.display) of \(String(describing: card.suit))")
    }
    
    private var indexes: some View {
        VStack {
            HStack {    // top left
                index
                Spacer()
            }
            Spacer()
            HStack {    // bottom right
                Spacer()
                index
                .rotationEffect(Angle(degrees: 180))
            }
        }
    }
    
    private var index: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(card.value == Card.Value.ten ? "" : " ")\(card.value.display)")
                .font(.caption)
                .bold()
                .foregroundColor(card.suit.color)
            Text(card.suit.symbol)
                .font(.caption2)
        }
        .padding(6)
    }
    
    private var pips: some View {
        Text("\(card.value.display)\(card.suit.symbol)")
            .bold()
            .font(.title2)
            .foregroundStyle(card.suit.color)
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
