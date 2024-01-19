import SwiftUI

func hexToRGB(_ hex: UInt) -> Color {
    let r = Double((hex >> 16) & 0xFF) / 255.0
    let g = Double((hex >> 8) & 0xFF) / 255.0
    let b = Double(hex & 0xFF) / 255.0
    return Color(red: r, green: g, blue: b)
}

public struct P190_GlassShape: View {
    @Binding var isPresented: Bool
    @State private var location: CGPoint = .zero
    @State var isDragging = false
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location
                self.isDragging = true
            }
            .onEnded {_ in self.isDragging = false}
    }
    
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                GlassBackground()
                ZStack {
                    CardView()
                        .overlay(
                            CardOverlayView()
                        )
                        .cornerRadius(16)
                }
                .position(location)
                .animation(.easeOut, value: location)
                .gesture(drag)
                
            }
            .onAppear {
                location = CGPoint(x: proxy.size.width * 0.5, y: proxy.size.height * 0.5)
            }
        }
    }
}

fileprivate
struct GlassBackground: View {
    var body: some View {
        GeometryReader { proxy in
            Circle()
                .fill(LinearGradient(colors: [hexToRGB(0xE9E1C1),
                                              hexToRGB(0xD7C47F)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 160, height: 160)
                .position(x: proxy.size.width * 0.3, y: proxy.size.height * 0.65)
            
            Circle()
                .fill(LinearGradient(colors: [hexToRGB(0x62CBF0),
                                              hexToRGB(0x3F8DED)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 280, height: 280)
                .position(x: proxy.size.width * 0.6, y: proxy.size.height * 0.4)
            
            Circle()
                .fill(LinearGradient(colors: [hexToRGB(0xAD4484),
                                              hexToRGB(0xDA6352)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 100, height: 100)
                .position(x: proxy.size.width * 0.7, y: proxy.size.height * 0.65)
        }
        .background(LinearGradient(colors: [hexToRGB(0x000000),
                                            hexToRGB(0x2D6ABC)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
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
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                VStack(alignment: .leading) {
                    Image(systemName: "person.crop.square")
                        .font(.largeTitle)
                    Spacer()
                    Spacer()
                    Text("3848   2234   5424   1058")
                        .font(.custom("Tamil Sangam MN", size: 20))
                        .fontWeight(.semibold)
                    Text("FABULA")
                        .font(.system(size: 10))
                        .padding(.top, 10)
                    Spacer()
                }
                .foregroundColor(Color.white.opacity(0.5))
                Spacer()
            }
        }
    }
}

// Define ContentView
struct ContentView: View {
    @State private var showGlassView = true
    
    var body: some View {
        //        ZStack {
        //            Color.clear
        //            Circle()
        //                .fill(LinearGradient(colors: [hexToRGB(0xAD4484),
        //                                              hexToRGB(0xDA6352)],
        //                                     startPoint: .topLeading,
        //                                     endPoint: .bottomTrailing))
        //                .padding()
        //                .padding()
        //            .padding()
        //            .padding()
        //            .padding().padding()
        //                .background(LinearGradient(colors: [hexToRGB(0x000000),
        //                                                    hexToRGB(0x2D6ABC)],
        //                                           startPoint: .topLeading,
        //                                           endPoint: .bottomTrailing))
        //            ZStack {
        //                Rectangle()
        //                    .fill(Color.clear)
        //                    .frame(width: 300, height: 200)
        //                    .background(Color.white.opacity(0.6))
        //                    .overlay(
        //                        ZStack {
        //                            RoundedRectangle(cornerRadius: 16)
        //                                .strokeBorder(LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        //                            VStack {
        //                                Spacer()
        //                                Spacer()
        //                                Spacer()
        //                                Spacer()
        //                                VStack(alignment: .leading) {
        //                                    Image(systemName: "person.crop.square")
        //                                        .font(.largeTitle)
        //                                    Spacer()
        //                                    Spacer()
        //                                    Text("3848   2234   5424   1058")
        //                                        .font(.custom("Tamil Sangam MN", size: 20))
        //                                        .fontWeight(.semibold)
        //                                    Text("FABULA")
        //                                        .font(.system(size: 10))
        //                                        .padding(.top, 10)
        //                                    Spacer()
        //                                }
        //                                .foregroundColor(Color.white.opacity(0.5))
        //                                Spacer()
        //                            }
        //                        }
        //                    )
        //                    .cornerRadius(16)
        //            }
        //        
        //            
        //        }
        
        
        VStack {
//            P190_GlassShape(isPresented: $showGlassView)
//                .frame(idealWidth: 300, idealHeight: 50)
//                .fixedSize(horizontal: true, vertical: true)
//                .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
        .popover(isPresented: $showGlassView) {
            P190_GlassShape(isPresented: $showGlassView)
                .frame(idealWidth: 300, idealHeight: 50)
                .fixedSize(horizontal: true, vertical: true)
                .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            //        }
                .frame(idealWidth: 300, idealHeight: 50)
            //        .fixedSize(horizontal: true, vertical: true)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        }
    }
}
    
    // Preview for ContentView
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
