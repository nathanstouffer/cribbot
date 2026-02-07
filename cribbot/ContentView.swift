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
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .fill(Color.white)
                        .frame(width: 100, height: 150)
                    Text("K❤️")
                        .font(.title)
                        .foregroundStyle(.red)
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
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
