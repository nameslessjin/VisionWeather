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
    
    //@Environment(WeatherKitManager.self) private var weatherKitManager
    
    var weatherKitManager: WeatherKitManager
    
    @State var headEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0, 0, -0.1]
        return headAnchor
    }()
    
    func selectWeatherEntity() -> String? {
        
        var weatherEntity : String? = nil
        
        if let condition = weatherKitManager.currentWeather?.condition {
            
            switch condition {
                
            case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries:
                weatherEntity = "SnowScene"
                break;
            case .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                weatherEntity = "RainScene"
                break
            default:
                break;
            }
        }
        
        return weatherEntity
    }
    
    func addCloudEntity() -> String? {
        
        var cloudEntity : String? = nil
        
        print("Check Cloud")
        print(weatherKitManager.currentWeather ?? "No Weather")
        print("End Check Cloud")
        
        if let condition = weatherKitManager.currentWeather?.condition {
            print(condition)
            switch condition {
                
            case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries, .cloudy, .mostlyCloudy, .partlyCloudy, .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                cloudEntity = "CloudScene"
                break;
            default:
                break;
            }
        }
         print(cloudEntity ?? "No cloud")
        return cloudEntity
    }
    
    var body: some View {
        RealityView { content in
            
            do {
                if let entityName = selectWeatherEntity() {
                    let weatherEntity = try await Entity(named: entityName, in: realityKitContentBundle)
                    headEntity.addChild(weatherEntity)
                }
                
                if let cloudName = addCloudEntity() {
                    let cloudEntity = try await Entity(named: cloudName, in: realityKitContentBundle)
                    headEntity.addChild(cloudEntity)
                    // guard let particleEmitter = cloudEntity.children[0].components[ParticleEmitterComponent.self]?
                }

                content.add(headEntity)
            } catch {
                print("Error in RealityView's make: \(error)")
            }
        }
    }
}

struct ImmersiveView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        ImmersiveView(weatherKitManager: weatherKitManager)
//        ImmersiveView()
            .previewLayout(.sizeThatFits)
//            .environment(weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
