//
//  Colors.swift
//  ChatGPT
//
//  Created by Xcode Developer on 12/30/23.
//

import SwiftUI

struct Colors: View {
    
    var body: some View {
        VStack {
            List(1..<11) { m in
                HStack {
                    Color.white
                        .overlay(Color.blue.opacity(Double(m) / 10.0))
                        .frame(width: 50, height: 50)
                    Color.white
                        .blendMode(.multiply)
                        .background(Color.blue.opacity(Double(m) / 10.0))
                        .frame(width: 50, height: 50)
                }
            }
        }
    }
}

struct Colors_Previews: PreviewProvider {
    static var previews: some View {
        Colors()
    }
}
