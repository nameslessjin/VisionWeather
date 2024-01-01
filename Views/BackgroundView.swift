//
//  BackgroundView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 1/1/24.
//

import SwiftUI
import SpriteKit

struct BackgroundView: View {
    
    @State var weatherKitManager: WeatherKitManager
    @State private var colors: [String] = ["DaySky", "DayGround"]
    
    func showCloud(size: CGSize) -> some View {
        
        // if clear and it is night then there is clear
        
        if let currentCondition = weatherKitManager.currentWeather?.condition,
           let isDay = weatherKitManager.currentWeather?.isDaylight
        {
            switch currentCondition {
                case .clear, .hot, .mostlyClear, .sleet:
                    return AnyView(Color.clear)
                case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries, .cloudy, .mostlyCloudy, .partlyCloudy, .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix, .foggy, .haze, .smoky:
                
                    return AnyView(SpriteView(scene: Cloud(size: size), options: [.allowsTransparency]))
                    // return AnyView(Color.clear)
                default:
                    return AnyView(Color.clear)
            }
            
        }
        
        return AnyView(Color.clear)
    }
    
    func showStar(size: CGSize) -> some View {
        
        // if clear and it is night then there is clear
        
        if let currentCondition = weatherKitManager.currentWeather?.condition,
           let isDay = weatherKitManager.currentWeather?.isDaylight
        {
            switch currentCondition {
                case .clear, .hot, .mostlyClear, .sleet, .cloudy, .partlyCloudy, .mostlyCloudy:
                        if !isDay {
                            return AnyView(SpriteView(scene: Star(size: size), options: [.allowsTransparency]))
                        }
                        return AnyView(Color.clear)
                default:
                    return AnyView(Color.clear)
            }
            
        }
        
        return AnyView(Color.clear)
    }
    
    
    
    func pickBackgroundColor() {
        
        if let isDay = weatherKitManager.currentWeather?.isDaylight {
            self.colors = isDay ? ["DaySky", "DayGround"] : ["NightSky", "NightGround"]
        }
        if let currentCondition = weatherKitManager.currentWeather?.condition,
           let isDay = weatherKitManager.currentWeather?.isDaylight
            {
            switch currentCondition {
                
                case .clear, .hot, .mostlyClear, .sleet, .blowingDust, .breezy, .windy, .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries:
                    break
                    
                case .cloudy, .mostlyCloudy, .partlyCloudy, .foggy, .haze, .smoky:
                    if isDay {
                        self.colors = ["CloudSky", "CloudGround"]
                    }
                case .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                    if isDay {
                        self.colors = ["RainSky", "RainGround"]
                    }
                @unknown default:
                    break
            }
        }
        
        return
    }
    
    var body: some View {
        GeometryReader() { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(self.colors[0]), Color(self.colors[1])]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                showCloud(size: geometry.size)
                showStar(size: geometry.size)
                
            }
        }
        .onAppear() {
            pickBackgroundColor()
        }
        .onChange(of: weatherKitManager.currentWeather) { _, _ in
            pickBackgroundColor()
            print(self.colors)
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        BackgroundView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
