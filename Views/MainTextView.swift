//
//  MainTextView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 1/1/24.
//

import SwiftUI

struct MainTextView: View {
    
    var weatherKitManager: WeatherKitManager
    
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

struct MainTextView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        MainTextView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
