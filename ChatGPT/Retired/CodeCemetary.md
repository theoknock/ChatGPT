#  Code Cemetary

```func fast(message: String) {
        let assistant_dict: Dictionary = ["assistant_id": "\(chatData.assistant_id)"] as [String : Any]
        let message_dict: [Dictionary] = [["role": "user", "content": "\(message)"]]
        var messages_dict: Dictionary = ["messages": [Dictionary<String, Any>]()] as [String : Any]
        messages_dict.updateValue(message_dict, forKey: "messages")
        let thread_dict: Dictionary = ["thread": [messages_dict]] as [String : Any]
        
        //        let fast_request: [String: Any] = [
        //            "assistant_id": "\(chatData.assistant_id)",
        //            "thread": thread_dict["thread"]!
        //        ]
        
        var fast_request: [String: Any] = [
            "assistant_id": (chatData.assistant_id),
            "thread": [[[String: Any]]]()
        ]
        fast_request.updateValue("\(chatData.assistant_id)", forKey: "assistant_id")
        fast_request.updateValue(messages_dict, forKey: "thread")
        ////print(fast_request)
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        ////print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: fast_request, options: [])
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer sk-PLHtIjMBpKlYKlSdkubXT3BlbkFJ7cRMuB8iajUFjwlHZaeQsk-4NeIFPyHFGBw0sO3OzJ4T3BlbkFJAiqQOavRmeOiMtTuG6w2sk-mCI1swWIuFQPbdJZTx3HT3BlbkFJVhxlQK5lZjI3kwpj6jj9sk-4AUf7mRfLSKGDzWydLPJT3BlbkFJqqn2UyG5gI1kQxBt4INP", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let message_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        list()
                    }
                } catch {
                    ////print("Error")
                }
            }
        }
        
        task.resume()
    }```
    



    
    //    func thread_run() {
    //
    //        for message in messages {
    //
    //        }
    //        let message_request: Dictionary = ["role": "user", "content": chatData.] as [String : Any]
    //
    //        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //
    //        let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
    //        request.httpBody = jsonData
    //
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.addValue("", forHTTPHeaderField: "Authorization")
    //        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
    //        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
    //
    //        let session = URLSession.shared
    //        let task = session.dataTask(with: request) { (data, response, error) in
    //            if error == nil && data != nil {
    //                DispatchQueue.main.async {
    //                    do {
    //                        if let message_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
    //                            if let contentArray = message_response["content"] as? [[String: Any]] {
    //                                if let textArray = (contentArray.first)!["text"] as? [String: Any] {
    //                                    if let value = textArray["value"] as? String {
    //                                        self.messages.append(Message(id: sha256(), prompt: value, response: ""))
    //                                        self.run()
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    } catch {
    //                        print("Error")
    //                    }
    //                }
    //            }
    //        }
    //        task.resume()
    //    }



    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        VStack {
//                            Text("Chat \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            MainView(chatData: chatData)
//                        }
//                    } label: {
//                        //                        MainView(chatData: chatData)
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("New Chat", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select a chat")
//        }
    }




//    func saveChat() {
//        let id = ChatModel(id: chatData.messages.last!.id)
//        let prompt = ChatModel(id: chatData.messages.last!.prompt)
//        let response = ChatModel(id: chatData.messages.last!.response)
//
//        modelContext.insert(id)
//        modelContext.insert(prompt)
//        modelContext.insert(response)
//    }


import SwiftUI

struct MessageView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
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
                        .background(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
                        .foregroundColor(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3125)))  //isTextFieldFocused ? Color.white : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)))
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                        .clipShape(Capsule())
                })
            }
            .ignoresSafeArea()
            //            .foregroundStyle(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        }
        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        
        // -------
        
        //        HStack {
        //            Spacer()
        //            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
        //                .stroke(Color.accentColor, lineWidth: 4.0)
        //                .frame(idealWidth: UIScreen.main.bounds.width * 0.875, idealHeight: 40)
        //                .fixedSize(horizontal: false, vertical: true)
        //            Spacer()
        //            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
        //                .stroke(Color.accentColor, lineWidth: 4.0)
        //                .frame(idealWidth: UIScreen.main.bounds.width * 0.125, idealHeight: 40)
        //                .fixedSize(horizontal: true, vertical: true)
        //            Spacer ()
        //        }
        //        .frame(idealWidth: UIScreen.main.bounds.width, idealHeight: 40)
        //        .fixedSize(horizontal: true, vertical: false)
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}



//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(chatData: ChatData())
//            .preferredColorScheme(.dark)
//    }
//}

------------------------------------

        //        .background(Color.clear)
        //                    .scrollContentBackground(.hidden)
        //                            Text(message.prompt)
        //                                .background {
        //                                    Color.clear
        ////                                        .blur(radius: 8, opaque: false)
        //                                }
        //                            .background(.white)
        
        ////                            .frame(width: UIScreen.main.bounds.width)
        //                            .padding(.top)
        //                            .foregroundStyle(Color.primary)
        //                            .background(Color.clear)
        //                        //                            .background(LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .top, endPoint: .bottom))
        //                            .lineLimit(nil)
        //                            .fixedSize(horizontal: true, vertical: false)
        //                            .onTapGesture {
        //                                UIPasteboard.general.string = message.prompt
        //                            }
        //                            .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10.0,  bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 10.0), style: .continuous))
        //                        }
        //                        .background {
        //                            LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .top, endPoint: .bottom)
        //                                        .blur(radius: 8, opaque: false)
        //                        }
        ////                        .background(LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .top, endPoint: .bottom))
        //
        //                        }.listRowSeparator(.hidden)
        //
        //                        //                        .padding()
        ////                                                .background(LinearGradient(gradient: Gradient(colors: [Color.init(uiColor: .systemBlue), Color.clear]), startPoint: .leading, endPoint: .trailing))
        ////                                                .blur(radius: 3.0)
        //                        //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
        //                        //                        .listRowInsets(.init(top: 0, leading: 100, bottom: 0, trailing: 0))
        //
        //                        Section {
        //                            VStack {
        //                                Text(message.response)
        //                                ////                            .frame(idealWidth: UIScreen.main.bounds.width)
        //                                //                            .padding(.bottom)
        //                                //                            .foregroundStyle(Color.primary)
        //                                ////                            .background(Color.clear)
        //                                //                        //                            .background(LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .bottom, endPoint: .top))
        //                                //                            .lineLimit(nil)
        //                                //                   )         .fixedSize(horizontal: true, vertical: false)
        //                                //                            .onTapGesture {
        //                                //                                UIPasteboard.general.string = message.response
        //                                //                            }
        //                                //                            .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0.0,  bottomLeading: 10.0, bottomTrailing: 10.0, topTrailing: 0.0), style: .continuous))
        //                                //
        //                                //
        //                                //
        //                            }
        //                        }.listRowSeparator(.hidden)
        //
        //                        //                        .padding()
        //                        //                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.clear]), startPoint: .leading, endPoint: .trailing))
        //                        //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
        //                    })
        ////                    .background(Color.clear)
        //                    }
        //
        //                })
        
        
        //        .listStyle(.plain)
        //        .background(Color.clear)
        //                    .scrollContentBackground(.hidden)
        
        //        .background(LinearGradient(gradient: .init(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)]), startPoint: .topTrailing, endPoint: .bottomLeading))
        
        //                        .listSectionSpacing(0)
        
        
        
        //                       })
        //            }
        //        }

# -------------------------------------------------------------------------------
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
//                .onTapGesture {
//                    UIPasteboard.general.string = prompt
//                    prompt = UIPasteboard.general.string!
//                }
//                .onf
//                .background {
////                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 25.0))
////                        .strokeBorder(Color.init(uiColor: .gray).opacity(0.25), lineWidth: 1.0) :
//                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//                        .fill(Color.init(uiColor: .gray).opacity(0.25))
//                }
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
                    .foregroundStyle(Color(.white).tertiary)
                
//                    .shadow(color: Color(.black), radius: 1.0)
            })
//            .shadow(color: Color(.white), radius: 5.0)
//            .safeAreaPadding(.trailing)
        }
        .foregroundColor(.white)
        
        //            ZStack(alignment: .trailing) {
        //                TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
        //
        //
        //    //            // yep, this just works out of the box
        //    //            Text("```code```\nTo **learn more**, *please* feel free to visit [SwiftUIRecipes](https://swiftuirecipes.com) for details, or check the `source code` at [Github page](https://github.com/globulus).")
        //            }
        
        
        //        ZStack(alignment: (.trailing), content: {
        //            HStack {
        //                TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
        //            }
        //            .padding(.trailing)
        //            Spacer()
        //            HStack {
        //                Button(action: {
        //                    Task {
        //                        let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //                        prompt = prompt_tidy
        //                        chatData.addMessage(message: prompt_tidy)
        //                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        //                        prompt = String()
        //                    }
        //                }, label: {
        //                    Label("", systemImage: "arrow.up.circle")
        //                        .symbolRenderingMode(.hierarchical)
        //                        .font(.largeTitle)
        //                        .imageScale(.large)
        //                        .labelStyle(.iconOnly)
        //                        .clipShape(Circle())
        //                })
        //                .padding(.leading)
        //            }
        ////            .ignoresSafeArea()
        ////            .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
        ////            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        //        })
        ////        .ignoresSafeArea()
        //        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
        //        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        //
        //        // -------
        //
        ////        HStack {
        ////            Spacer()
        ////            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
        ////                .stroke(Color.accentColor, lineWidth: 4.0)
        ////                .frame(idealWidth: UIScreen.main.bounds.width * 0.875, idealHeight: 40)
        ////                .fixedSize(horizontal: false, vertical: true)
        ////            Spacer()
        ////            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
        ////                .stroke(Color.accentColor, lineWidth: 4.0)
        ////                .frame(idealWidth: UIScreen.main.bounds.width * 0.125, idealHeight: 40)
        ////                .fixedSize(horizontal: true, vertical: true)
        ////            Spacer ()
        ////        }
        ////        .frame(idealWidth: UIScreen.main.bounds.width, idealHeight: 40)
        ////        .fixedSize(horizontal: true, vertical: false)
        //
        //    }
        
        //    var body: some View {
        //        ZStack {
        //            color.BaseColor
        //                .edgesIgnoringSafeArea(.all)
        //
        //                    TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
        //                        .padding()
        //                        .focused($isTextFieldFocused)
        //                        .textInputAutocapitalization(.never)
        //                        .disableAutocorrection(true)
        //
        //
        //                    Button(action: {
        //                        Task {
        //                            let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //                            prompt = prompt_tidy
        //                            chatData.addMessage(message: prompt_tidy)
        //                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        //                            prompt = String()
        //                        }
        //                    }, label: {
        //                        Label("", systemImage: "arrow.up.circle")
        //                            .foregroundColor(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3125))) // isTextFieldFocused ? Color.white : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)))
        //                            .symbolRenderingMode(.hierarchical)
        //                            .font(.largeTitle)
        //                            .imageScale(.large)
        //                            .labelStyle(.iconOnly)
        ////                            .clipShape(Circle())
        //                    })
        //                    .background(
        //                        Circle()
        //                            .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
        //                            .modifier(NeumorphismModifier())
        //                    )
        //                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        //
        //                }
        //                .ignoresSafeArea()
        //
        ////                .background(
        ////                    RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)
        ////                        .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
        ////                        .modifier(NeumorphismModifier())
        ////                )
        //                //                .background(
        //                //                    RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)
        //                //                        .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
        //                //                        .modifier(NeumorphismModifier())
        //                //                )
        //                //                .clipShape(/*RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)*/)
        //            }
        //
        ////            .background(
        //                //                RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)
        //                //                    .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
        //                //                    .modifier(NeumorphismModifier())
        ////            )
        //        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

