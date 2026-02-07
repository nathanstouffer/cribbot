//
//  ContentView.swift
//  Cribbot
//
//  Created by Nathan Stouffer on 2/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
            VStack {
                CardView()
                Circle()
                    .blur(radius: 10)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
