//
//  VisionWeatherApp.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/31/23.
//

import SwiftUI
import CoreLocation


@main
struct VisionWeatherApp: App {
    
    @State var weatherKitManager = WeatherKitManager()
    
    var body: some Scene {
        
        
        
        WindowGroup {
            ContentView(weatherKitManager: weatherKitManager)
                .task {
                    await weatherKitManager.getWeather()
                }
        }
        .defaultSize(width: 1500, height: 900)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(weatherKitManager: weatherKitManager)
        }
        //.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
