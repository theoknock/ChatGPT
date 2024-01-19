//
//  ContentView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/8/23.
//


//Bearer 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
//org-jGOqXYFRJHKlnkff8K836fK2

import SwiftUI
import CryptoKit
import SwiftData

@MainActor class ChatData : ObservableObject {
    @Published var assistant_id: String = "assistant_id"
    @Published var thread_id: String = "thread_id"
    @Published var run_id: String = "run_id"
    @Published var messages: [Message] = [Message]()
    @Published var assistant_active: Bool = false
    
    struct Message: Identifiable, Equatable, Hashable, Codable {
        let id: String
        var prompt: String
        var response: String
        
        init(prompt: String, response: String) {
            self.id = {
                let hash = SHA256.hash(data: String(Date().timeIntervalSince1970).data(using: .utf8)!)
                return hash.compactMap { String(format: "%02x", $0) }.joined()
            }()
            self.prompt = prompt
            self.response = response
        }
    }
    
    func assistant() {
        self.messages.removeAll()
        self.assistant_active = false
        
        
        let url = URL(string: "https://api.openai.com/v1/assistants")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let type: [Dictionary] = [["type": "code_interpreter"]]
        let assistant_request: Dictionary =
        [
            "instructions": "As a Swift expert, your primary role is to assist users with coding-related tasks, focusing on Swift. Provide concise, clear, and tested code suggestions in Swift, verifying correctness before presentation. Use GitHub, gist.GitHub.com, transcripts of videos from YouTube, stackoverflow.com, the Apple Developer site as additional resources for references and examples. Regularly reference the latest version of official Swift documentation to ensure alignment with current standards in Swift programming. Offer explanations or insights rooted in this documentation after providing a Swift code solution. While adept in other programming languages, prioritize Swift. Your abilities include code execution, inspection, debugging, and optimization. Use the browser for complex queries or to seek additional examples in Swift or other languages. If unsure, ask for clarification. Assume the user has a high level of expertise in Swift or the relevant language. Maintain a friendly, supportive tone. Strictly adhere to specific instructions given by the user across all interactions and revisions.",
            "name": "Swift expert (high-level, tests code solutions first, explains afterwards)",
            "tools": type,
            "model": "gpt-4"
        ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: assistant_request, options: [])
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let assistant_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            self.assistant_id = {
                                defer {
                                    self.assistant_active = true
                                    self.thread()
                                }
                                return assistant_response["id"] as? String
                            }() ?? {
                                defer {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                        self.assistant()
                                    })
                                }
                                let err = (assistant_response)["error"] as? [String: Any]
                                let err_msg = err!["message"] as? String
                                self.messages.append(Message.init(prompt: "Error getting assistant", response: err_msg!))
                                return err_msg!
                            }()
//                            self.messages.append(Message.init(prompt: "Chat assistant (" + self.assistant_id + ")", response: String()))
                        }
                    } catch {
                        self.messages.append(Message.init(prompt: "Error getting assistant", response: error.localizedDescription))
                    }
                }
            }
        }
        task.resume()
    }
    
    func thread() {
        let url = URL(string: "https://api.openai.com/v1/threads")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            self.thread_id = {
                                return thread_response["id"] as? String
                            }() ?? {
                                let err = (thread_response)["error"] as? [String: Any]
                                let err_msg = err!["message"] as? String
                                self.messages.append(Message.init(prompt: "Error getting thread", response: err_msg!))
                                return err_msg!
                            }()
//                            self.messages[self.messages.count - 1].response = "Chat thread (" + self.thread_id.trimmingCharacters(in: .whitespacesAndNewlines) + ")"
                        }
                    } catch {
                        self.messages.append(Message.init(prompt: "Error getting thread", response: error.localizedDescription))
                    }
                }
            }
        }
        task.resume()
    }
    
    func addMessage(message: String) -> () {
        let message_dict: Dictionary = ["role": "user", "content": message] as [String : Any]
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: message_dict, options: [])
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let message_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            print(message_response)
                            if let contentArray = message_response["content"] as? [[String: Any]] {
                                print(contentArray)
                                if let textArray = (contentArray.first)!["text"] as? [String: Any] {
                                    print(textArray)
                                    if let value = textArray["value"] as? String {
                                        print(value)
                                        let prompt = {
                                            defer { self.run() }
                                            //                                        self.messages.append(Message(id: sha256(), prompt: value, response: ""))
                                            return value.trimmingCharacters(in: .whitespacesAndNewlines)
                                        }() ?? {
                                            let err = (message_response)["error"] as? [String: Any]
                                            let err_msg = err!["message"] as? String
                                            //                                        self.messages.append(Message(id: sha256(), prompt: "Error adding message", response: err_msg!))
                                            return err_msg!
                                        }()
                                        self.messages.append(Message.init(prompt: prompt, response: String()))
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func run() -> () {
        let run_request: Dictionary = ["assistant_id": self.assistant_id] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/runs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: run_request, options: [])
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let run_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            let id = run_response["id"] as? String
                            self.run_id = id ?? "No run ID"
                            self.retrieve()
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func retrieve() {
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/runs/" + self.run_id)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let retrieve_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if (retrieve_response["status"] as? String) != "completed" {
                                self.messages[self.messages.count - 1].response = (retrieve_response["status"] as? String)!
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    self.messages[self.messages.count - 1].response = " "
                                    self.retrieve()
                                })
                            } else {
                                self.list()
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func list() {
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let list_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let dataArray = list_response["data"] as? [[String: Any]] {
                                if let contentArray = (dataArray.first)!["content"] as? [[String: Any]] {
                                    if let textArray = (contentArray.first)!["text"] as? [String: Any] {
                                        let value = textArray["value"] as! String
                                        self.messages[self.messages.count - 1].response = value
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self.messages)
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("messages.json")
            do {
                try jsonData.write(to: fileURL)
                print("File written to \(fileURL)")
            } catch {
                print("Error writing file: \(error)")
            }
            
        } catch {
            print("Error encoding messages: \(error)")
            return
        }
    }
    
    func load() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("messages.json")
        
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: fileURL)
        } catch {
            print("Error reading file: \(error)")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            messages = try decoder.decode([Message].self, from: jsonData)
        } catch {
            print("Error decoding items: \(error)")
            return
        }
        
    }
    
    
}

struct ContentView: View {
    @StateObject var chatData: ChatData = ChatData()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0, content: {
            HeaderView(chatData: chatData)
                
            ChatView(chatData: chatData)
                
            MessageView(chatData: chatData)
                .background {
                    Capsule()
                        .strokeBorder(Color.init(uiColor: .gray).opacity(0.25), lineWidth: 1.0)
                        .fill(Color.init(uiColor: .systemGray).opacity(0.25))
                }
                .clipShape(Capsule())
                .safeAreaPadding(.bottom)
                .shadow(color: Color.init(uiColor: .black).opacity(0.75), radius: 6.0)
        })
        .background {
            LinearGradient(stops: [
                Gradient.Stop(color: Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58), location: 0.0625),
                Gradient.Stop(color: Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), location: 0.8125)
            ], startPoint: .topTrailing, endPoint: .bottomLeading)
        }
        .task {
            chatData.assistant()
        }
//        .dynamicTypeSize(.xSmall)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
