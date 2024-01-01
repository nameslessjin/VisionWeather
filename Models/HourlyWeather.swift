//
//  HourlyWeather.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/25/23.
//

import Foundation

struct HourlyWeather: Identifiable, Decodable {
    let id: Int
    let hour: String
    let temperature: Int
    let imageURL: String
}

struct HourlyWeatherResponse: Decodable {
    let request: [HourlyWeather]
}

struct HourlyWeatherMockData {
    
    static let Hourly0 = HourlyWeather(id: 0, hour: "Now", temperature: 50, imageURL: "moon.zzz.fill")
    static let Hourly1 = HourlyWeather(id: 1, hour: "1PM", temperature: 45, imageURL: "moon.fill")
    static let Hourly2 = HourlyWeather(id: 2, hour: "2PM", temperature: 55, imageURL: "cloud.moon.fill")
    static let Hourly3 = HourlyWeather(id: 3, hour: "3PM", temperature: 65, imageURL: "moon.dust.fill")
    static let Hourly4 = HourlyWeather(id: 4, hour: "4PM", temperature: 67, imageURL: "cloud.rain.fill")
    static let Hourly5 = HourlyWeather(id: 5, hour: "5PM", temperature: 62, imageURL: "sun.rain.fill")
    static let Hourly6 = HourlyWeather(id: 6, hour: "6PM", temperature: 53, imageURL: "sun.max.fill")
    static let Hourly7 = HourlyWeather(id: 7, hour: "7PM", temperature: 47, imageURL: "cloud.fill")
    static let Hourly8 = HourlyWeather(id: 8, hour: "8PM", temperature: 43, imageURL: "sun.snow.fill")
    static let Hourly9 = HourlyWeather(id: 9, hour: "9PM", temperature: 47, imageURL: "cloud.fill")
    static let Hourly10 = HourlyWeather(id: 10, hour: "10PM", temperature: 57, imageURL: "cloud.snow.fill")
    static let Hourly12 = HourlyWeather(id: 11, hour: "11PM", temperature: 67, imageURL: "wind.snow.fill")
    
    static let HourlyWeatherData: [HourlyWeather] = [Hourly0, Hourly1, Hourly2, Hourly3, Hourly4, Hourly5, Hourly6, Hourly7, Hourly8, Hourly9]
    
}
