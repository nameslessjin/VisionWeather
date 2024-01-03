//
//  VisionWeatherApp.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/31/23.
//

import SwiftUI
import CoreLocation
import MapKit

@main
struct VisionWeatherApp: App {
    
    var weatherKitManager = WeatherKitManager()
    @State var selectedPlacemark: MKPlacemark?
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(selectedPlacemark: $selectedPlacemark, weatherKitManager: weatherKitManager)
//            LocationSearchView()
                .onAppear() {
                    Task {
                        await weatherKitManager.getWeather(placemark: selectedPlacemark)
                    }
                }
                .onChange(of: selectedPlacemark) { _, _ in
                    Task {
                        await weatherKitManager.getWeather(placemark: selectedPlacemark)
                    }
                }
        }
        .defaultSize(width: 1500, height: 900)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(weatherKitManager: weatherKitManager)
//            ImmersiveView()
        }
        //.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
