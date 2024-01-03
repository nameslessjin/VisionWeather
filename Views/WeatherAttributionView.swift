//
//  WeatherAttributionView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 1/3/24.
//

import SwiftUI

struct WeatherAttributionView: View {
    
    var weatherKitManager: WeatherKitManager
    
    var body: some View {
        if let attrib = weatherKitManager.attribution {
            HStack {
                AsyncImage(
                    url: attrib.squareMarkURL,
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, maxHeight: 30)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                
                Link(destination: attrib.legalPageURL) {
                    Text("Weather Data Attribution")
                        .font(Font.footnote)
                }
            }
            .padding()
        }
    }
}

struct WeatherAttributionView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        WeatherAttributionView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}

