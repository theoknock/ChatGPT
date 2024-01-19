//
//  MessageView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/24/23.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    @FocusState private var isTextFieldFocused: Bool
    
    let gradient = LinearGradient(stops: [
        Gradient.Stop(color: Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58), location: 0.1),
        Gradient.Stop(color: Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), location: 0.9)
    ], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                .focused($isTextFieldFocused)
                .font(.body).dynamicTypeSize(.large)
                .fontWeight(isTextFieldFocused ? .light : .ultraLight)
                .lineLimit(1, reservesSpace: false)
                .lineSpacing(1.0)
                .safeAreaPadding(.leading)
                .frame(idealWidth: UIScreen.main.bounds.width * 0.875, idealHeight: UIScreen.main.bounds.height * 0.125)
                .padding(.leading)
            Spacer()
            Button(action: {
                Task {
                    let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "```", with: "`")
                    prompt = prompt_tidy
                    chatData.addMessage(message: prompt_tidy)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    prompt = String()
                }
            }, label: {
                Label("", systemImage: "arrow.up.circle")
                    .symbolRenderingMode(.hierarchical)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color(.white))
            })
        }
        .foregroundColor(.white)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
