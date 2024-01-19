//
//  HeaderView.swift
//  ChatGPT
//
//  Created by Xcode Developer on 12/28/23.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var chatData: ChatData
    @Environment(\.textCase) private var textCase: Text.Case?
//    @State private var assistant_active = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0, content: {
//            Label("ChatGTP 4 Swift CodePilot", systemImage: chatData.assistant_active ? "person.wave.2.fill" : "person.wave.2")
//                .symbolRenderingMode(.hierarchical)
//                .font(.title2).dynamicTypeSize(.large)
//                .imageScale(.large)
//                .labelStyle(.titleAndIcon)
//                .foregroundStyle(.white)
//            Text("Copyright © 2024 James Alan Bush. All rights reserved.")
//                .font(.caption).dynamicTypeSize(.small)
//                .padding(.top)
            Button(action: {
                withAnimation {
                    chatData.assistant_active = false
                    chatData.assistant()
                }
            }, label: {
                Label("ChatGPT 4 Swift CodePilot", systemImage: "message.badge.circle")
                    .labelStyle(HeaderViewLabelStyle(assistant_active: chatData.assistant_active))
            })
        })
        .frame(idealWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height * 0.0625, maxHeight: UIScreen.main.bounds.height * 0.0625, alignment: .bottom)
    }
}

fileprivate struct HeaderViewLabelStyle: LabelStyle {
    let assistant_active: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(assistant_active ? .green : .red)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .symbolVariant(assistant_active ? .none : .none)
                configuration.title
                    .font(.title2).dynamicTypeSize(.small)
//                    .textCase(.uppercase)
                    .foregroundColor(.white)
            }
        }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
