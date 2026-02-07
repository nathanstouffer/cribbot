//
//  CardView.swift
//  cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(Color.white)
                .frame(width: 100, height: 150)
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 10)
            Text("K❤️")
                .font(.title)
                .foregroundStyle(.red)
        }    }
}

#Preview {
    CardView()
}
