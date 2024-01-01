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

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
