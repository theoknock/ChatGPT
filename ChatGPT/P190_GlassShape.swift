//
//  SwiftUIView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/27/23.
//

import SwiftUI

public struct P190_GlassShape: View {
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                GlassBackground()
                ZStack {
                    CardView()
                        .overlay(
                            CardOverlayView(chatData: ChatData())
                        )
                        .cornerRadius(16)
                }
                
            }
        }
    }
}

fileprivate
struct GlassBackground: View {
    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerSize: CGSize(width: 15.0, height: 15.0))
                .fill(LinearGradient(colors: [Color.white, Color(uiColor: UIColor(Color(hue: 214.0/360.0, saturation: 0.76, brightness: 0.74)))],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: proxy.size.width * 0.875, height: proxy.size.height * 0.125)
                .position(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)

        }
        .background(LinearGradient(stops: [
            Gradient.Stop(color: Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58), location: 0.1),
            Gradient.Stop(color: Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), location: 0.9)
        ], startPoint: .bottomLeading, endPoint: .topTrailing))
    }
}

fileprivate
struct CardView: View {
    var body: some View {
        if #available(macOS 12.0, *) {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .background(.ultraThinMaterial)
        } else {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .background(Color.white.opacity(0.6))
        }
    }
}

fileprivate
struct CardOverlayView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                                .padding()
                                .focused($isTextFieldFocused)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        
                        
                        HStack {
                            Button(action: {
                                Task {
                                    let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                                    prompt = prompt_tidy
                                    chatData.addMessage(message: prompt_tidy)
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    prompt = String()
                                }
                            }, label: {
                                Label("", systemImage: "arrow.up.circle")
                                    .foregroundColor(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3125))) // isTextFieldFocused ? Color.white : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)))
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .labelStyle(.iconOnly)                            })
                            .background(
                                Circle()
                                    .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
                                    .modifier(NeumorphismModifier())
                            )
                            
                        }
                        .ignoresSafeArea()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                    }
                    
                }
                .foregroundColor(Color.white.opacity(0.5))
            }
        }
    }
}

struct P190_GlassShape_Previews: PreviewProvider {
    static var previews: some View {
        P190_GlassShape()
    }
}
