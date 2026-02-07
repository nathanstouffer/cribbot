//
//  ContentView.swift
//  cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
            VStack {
                CardView()
                Circle()
                    .fill(Color.red)
                    .blur(radius: 10)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
