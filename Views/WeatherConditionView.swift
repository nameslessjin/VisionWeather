//
//  WeatherConditionView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/30/23.
//

import SwiftUI

struct WeatherConditionView: View {
    // feels like, humidity, pressure, UV index, Visibility, wind
    @State var weatherKitManager: WeatherKitManager
    
    func createNewsView() -> some View {
        
        HStack(){
            VStack {
                Image(systemName: "thermometer.variable.and.figure")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.apparentTemp)°")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
            
            Spacer()
            
            VStack {
                Image(systemName: "humidity.fill")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.humidity)%")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
            
            Spacer()
            
            VStack {
                Image(systemName: "barometer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.pressure) inHg")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
            
            Spacer()
            
            VStack {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.uvIndex) UV")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
            
            Spacer()
            
            VStack {
                Image(systemName: "eye.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.visibility) mi")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
            
            Spacer()
            
            VStack {
                Image(systemName: "wind")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(weatherKitManager.wind) MPH")
                    .font(.system(size: 24, weight: .medium))
            }
            .padding()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()

    }
    
    var body: some View {
        PanelView() {
            createNewsView()
        }
    }
}

//#Preview {
//    
//    let weatherKitManager = WeatherKitManager()
//    WeatherConditionView(weatherKitManager: weatherKitManager)
//        .task {
//            await weatherKitManager.getWeather()
//        }
//}

struct WeatherConditionView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        WeatherConditionView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
