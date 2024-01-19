//
//  MessageSymbol.swift
//  ChatGPT
//
//  Created by Xcode Developer on 12/28/23.
//

import SwiftUI

struct MessageSymbol: View {
    let gradient = LinearGradient(stops: [
        Gradient.Stop(color: Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58), location: 0.0625),
        Gradient.Stop(color: Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), location: 0.8125)
    ], startPoint: .bottom, endPoint: .top)
    
    var body: some View {
        Image(systemName: "arrow.up.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .mask(
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                )
                    .foregroundStyle(gradient)
                    .background(.clear)
    }
}

#Preview {
    MessageSymbol()
}
