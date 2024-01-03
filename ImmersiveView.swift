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
    
//    @State private var weatherEntity: Entity? = nil
//    @State private var cloudEntity: Entity? = nil
    
    @State var weatherState = "EmptyScene"
    @State var cloudState = "EmptyScene"
    
    @State var headEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0, 0, -0.1]
        headAnchor.name = "headEntity"
        return headAnchor
    }()
    
    func selectWeatherEntity() -> String {
        
        var weatherEntity : String = "EmptyScene"
        
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
    
    func addCloudEntity() -> String {
        
        var cloudEntity : String = "EmptyScene"
        
        if let condition = weatherKitManager.currentWeather?.condition {
            switch condition {
                
            case .blizzard, .blowingSnow, .flurries, .frigid, .heavySnow, .snow, .sunFlurries, .cloudy, .mostlyCloudy, .partlyCloudy, .drizzle, .freezingDrizzle, .freezingRain, .hail, .heavyRain, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .strongStorms, .sunShowers, .thunderstorms, .tropicalStorm, .wintryMix:
                cloudEntity = "CloudScene"
                break;
            default:
                break;
            }
        }
        return cloudEntity
    }
    
    var body: some View {
        RealityView { content in
            
            do {
                
                let weatherEntity = try await Entity(named: weatherState, in: realityKitContentBundle)
                let cloudEntity = try await Entity(named: cloudState, in: realityKitContentBundle)
                weatherEntity.name = "weatherEntity"
                cloudEntity.name = "cloudEntity"
                headEntity.addChild(weatherEntity)
                headEntity.addChild(cloudEntity)
                
//                if let weatherName = selectWeatherEntity() {
//                    let weatherEntity = try await Entity(named: weatherName, in: realityKitContentBundle)
//                    headEntity.addChild(weatherEntity)
//                }
//                
//                if let cloudName = addCloudEntity() {
//                    let cloudEntity = try await Entity(named: cloudName, in: realityKitContentBundle)
//                    headEntity.addChild(cloudEntity)
//                    // guard let particleEmitter = cloudEntity.children[0].components[ParticleEmitterComponent.self]?
//                }

                content.add(headEntity)
            } catch {
                print("Error in RealityView's make: \(error)")
            }
        } update: { _ in
        }
        .onAppear() {
            self.weatherState = selectWeatherEntity()
            self.cloudState = addCloudEntity()
        }
        .onChange(of: weatherKitManager.condition) { _, _ in

            Task {
                await updateEntityIfNeeded(
                    entityName: "weatherEntity",
                    currentState: self.weatherState,
                    determineState: selectWeatherEntity,
                    updateState: {newState in
                        self.weatherState = newState
                    })
                
                await updateEntityIfNeeded(
                    entityName: "cloudEntity",
                    currentState: self.cloudState,
                    determineState: addCloudEntity,
                    updateState: {newState in
                        self.cloudState = newState
                    })
            }
        }
    }
    
    func updateEntityIfNeeded(entityName: String, currentState: String, determineState: () -> String?, updateState: @escaping (String) -> Void) async {
        
        if let entity = await headEntity.findEntity(named: entityName) {
            if let newState = determineState(), currentState != newState {
                await entity.removeFromParent()
                do {
                    let newEntity = try await Entity(named: newState, in: realityKitContentBundle)
                    
                    DispatchQueue.main.async {
                        newEntity.name = entityName
                        updateState(newState)
                    }
                    await headEntity.addChild(newEntity)
                } catch {
                    print("Error loading entity: \(error)")
                }
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
