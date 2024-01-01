//
//  ContentView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/23/23.
//

import SwiftUI
import RealityKit
//import RealityKitContent
import CoreLocation
import SpriteKit

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State var weatherKitManager: WeatherKitManager
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                SpriteView(scene: SnowFall(size: geometry.size), options: [.allowsTransparency])
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    MainTextView(weatherKitManager: weatherKitManager)
                        .padding(.vertical)
                    
                    if weatherKitManager.alert != nil {
                        NewsView(news: weatherKitManager.alert ?? "No News")
                    }
                    
                    WeatherConditionView(weatherKitManager: weatherKitManager)

                    HourlyForecastView(weatherKitManager: weatherKitManager)
                    
                    DayForecastView(weatherKitManager: weatherKitManager)
                }
                .padding()
                .frame(width: geometry.size.width * 0.8)
            }
        }
        
//        .onChange(of: showImmersiveSpace) { _, newValue in
//            Task {
//                if newValue {
//                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
//                    case .opened:
//                        immersiveSpaceIsShown = true
//                    case .error, .userCancelled:
//                        fallthrough
//                    @unknown default:
//                        immersiveSpaceIsShown = false
//                        showImmersiveSpace = false
//                    }
//                } else if immersiveSpaceIsShown {
//                    await dismissImmersiveSpace()
//                    immersiveSpaceIsShown = false
//                }
//            }
//        }
    }
}

struct MainTextView: View {
    
    @State var weatherKitManager: WeatherKitManager
    
    var body: some View {
        
        VStack {
            Text(weatherKitManager.city)
                .font(.system(size: 40, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Text("\(weatherKitManager.temp)°")
                .font(.system(size: 80, design: .default))
            Text("\(weatherKitManager.condition)")
                .font(.system(size: 28, weight: .medium, design: .default))
            
            HStack{
                Text("H:\(weatherKitManager.dayHTemp)°")
                    .font(.system(size: 28, weight: .medium, design: .default))
                Text("L:\(weatherKitManager.dayLTemp)°")
                    .font(.system(size: 28, weight: .medium, design: .default))
            }
        }
    }
}


#Preview(windowStyle: .automatic) {
    
    let weatherKitManager = WeatherKitManager()
    
    ContentView(weatherKitManager: weatherKitManager)
        .task {
            await weatherKitManager.getWeather()
        }
}


class RainFall: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        addChild(node)
        
    }
}

class SnowFall: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
//        size = view.bounds.size
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "SnowFall.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        addChild(node)
        
    }
}
//
//class RainFallLanding: SKScene {
//
//    var frameSize: CGSize!
//
//    override init(size: CGSize) {
//        super.init(size: size)
//        self.scaleMode = .resizeFill
//        self.backgroundColor = .clear
//        self.anchorPoint = CGPoint(x: 0.5, y: 1)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func sceneDidLoad() {
//
//        scaleMode = .resizeFill
//
//        backgroundColor = .clear
//
//
//        anchorPoint = CGPoint(x: 0.5, y: 1)
//
//        // creating node and adding to scene
//        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
//        node.particlePositionRange.dx = self.size.width * 1.5
//        addChild(node)
//
//    }
//}
