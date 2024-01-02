//
//  ContentView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/23/23.
//

import SwiftUI
import RealityKit
import RealityKitContent
import CoreLocation
import SpriteKit

struct ContentView: View {

    @State private var showImmersiveSpace = true
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var weatherKitManager: WeatherKitManager
    
    func showSpriteView(size: CGSize) -> some View {
        
        if let currentCondition = weatherKitManager.currentWeather?.condition {
            switch currentCondition {
                
            case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries:
                return AnyView(SpriteView(scene: SnowFall(size: size), options: [.allowsTransparency]))
            case .blowingDust, .breezy, .windy:

                return AnyView(Color.clear)
            case .clear, .hot, .mostlyClear, .sleet:

                return AnyView(Color.clear)
            case .cloudy, .mostlyCloudy, .partlyCloudy:

                return AnyView(Color.clear)
            case .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                return AnyView(SpriteView(scene: RainFall(size: size), options: [.allowsTransparency]))
            case .foggy, .haze, .smoky:

                return AnyView(Color.clear)
            @unknown default:

                return AnyView(Color.clear)
            }
        }
        
        return AnyView(Color.clear)
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                BackgroundView(weatherKitManager: weatherKitManager)

                showSpriteView(size: geometry.size)
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
        .task {
            await openImmersiveSpace(id: "ImmersiveSpace")
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



#Preview(windowStyle: .automatic) {
    
    let weatherKitManager = WeatherKitManager()
    
    ContentView(weatherKitManager: weatherKitManager)
        .task {
            await weatherKitManager.getWeather()
        }
}

