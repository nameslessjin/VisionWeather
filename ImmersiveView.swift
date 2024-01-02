//
//  ImmersiveView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/31/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State var weatherKitManager: WeatherKitManager
    
    @State var headEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0, -0.3, 0.1]
        return headAnchor
    }()
    
    func selectWeatherEntity() -> String {
        var weatherEntity = "DefaultScene"
        if let condition = weatherKitManager.currentWeather?.condition {
            
            switch condition {
                
            case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries:
                weatherEntity = "SnowScene"
                break;
            case .blowingDust, .breezy, .windy:

                break;
            case .clear, .hot, .mostlyClear, .sleet:

                break;
            case .cloudy, .mostlyCloudy, .partlyCloudy:
                weatherEntity = "CloudScene"
                break;
            case .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                weatherEntity = "RainScene"
                break
            case .foggy, .haze, .smoky:
                break;
            @unknown default:
                break;
            }
        }
        
        return weatherEntity
    }
    
    var body: some View {
        RealityView { content in
            
            do {
                let weatherEntity = try await Entity(named: "CloudScene", in: realityKitContentBundle)
                headEntity.addChild(weatherEntity)
                content.add(headEntity)
            } catch {
                print("Error in RealityView's make: \(error)")
            }
        }
    }
}

//#Preview {
//    let weatherKitManager = WeatherKitManager()
//    
//    ImmersiveView(weatherKitManager: weatherKitManager)
//        .previewLayout(.sizeThatFits)
//        .task {
//            await weatherKitManager.getWeather()
//        }
//}

struct ImmersiveView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        ImmersiveView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
