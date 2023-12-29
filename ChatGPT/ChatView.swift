//
//  ListView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatData: ChatData
    @State private var message_id: String?
    
    var body: some View {
        ScrollViewReader { scrollView in
            Section {
                List(chatData.messages) { message in
                    Section {
                        HStack(alignment: .bottom, spacing: 0.0, content: {
                            Text(message.prompt)
                                .font(.body).dynamicTypeSize(.large)
                                .font(.body).fontWeight(.thin)
                            
                        })
                        .listRowBackground(
                            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 25.0))
                                .strokeBorder(Color.init(uiColor: .gray).opacity(0.25), lineWidth: 1.0)
                            //                            .shadow(color: Color.gray, radius: 3.0)
                        )
                        
                        HStack(alignment: .top, spacing: 0.0, content: {
                            Text(message.response)
                                .font(.body).dynamicTypeSize(.large)
                                .font(.body).fontWeight(.light)
                        })
                        .listRowBackground(
                            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0.0, bottomLeading: 25.0, bottomTrailing: 25.0, topTrailing: 0.0))
                                .fill(Color.init(uiColor: .gray).opacity(0.25))
                            //                            .shadow(color: Color.gray, radius: 3.0)
                        )
                    }
                    .listSectionSpacing(25.0)
                    .id(message.id)
                }
                .listStyle(.plain)
                .listRowSpacing(0)
                .scrollContentBackground(.hidden)
                .onAppear(perform: {
                    if message_id == chatData.messages.last?.id {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            scrollView.scrollTo(message_id, anchor: .bottom)
                        }
                    }
                })
            }
            
        }
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //        ChatView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}

struct OrientationChangeDetector: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onOrientationChange(perform action: @escaping () -> Void) -> some View {
        self.modifier(OrientationChangeDetector(action: action))
    }
}


/*
 .padding()
 .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3)))
 .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
 */
