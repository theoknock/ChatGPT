//
//  HeaderView.swift
//  ChatGPT
//
//  Created by Xcode Developer on 12/28/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
            VStack(alignment: .center, spacing: 0.0, content: {
                Text("ChatGTP 4 Swift CodePilot")
                    .font(.title).dynamicTypeSize(.small)
                Text("Copyright © 2024 James Alan Bush. All rights reserved.")
                    .font(.caption).dynamicTypeSize(.small)
            })
            .frame(idealWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height * 0.0625, maxHeight: UIScreen.main.bounds.height * 0.0625, alignment: .bottom)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
