//
//  DayWeather.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/29/23.
//

import Foundation

struct DailyWeather: Identifiable, Decodable {
    let id: Int
    let day: String
    let hTemp: Int
    let lTemp: Int
    let imageURL: String
}

struct DailyWeatherResponse: Decodable {
    let request: [DailyWeather]
}

struct DailyWeatherMockData {
    
    static let Day0 = DailyWeather(id: 0, day: "Today", hTemp: 50, lTemp: 34, imageURL: "moon.zzz.fill")
    static let Day1 = DailyWeather(id: 1, day: "Fri", hTemp: 45, lTemp: 30, imageURL: "moon.fill")
    static let Day2 = DailyWeather(id: 2, day: "Sat", hTemp: 55, lTemp: 35, imageURL: "cloud.moon.fill")
    static let Day3 = DailyWeather(id: 3, day: "Sun", hTemp: 65, lTemp: 40, imageURL: "moon.dust.fill")
    static let Day4 = DailyWeather(id: 4, day: "Mon", hTemp: 75, lTemp: 54, imageURL: "cloud.rain.fill")
    static let Day5 = DailyWeather(id: 5, day: "Tue", hTemp: 100, lTemp: 43, imageURL: "sun.rain.fill")
    static let Day6 = DailyWeather(id: 6, day: "Wed", hTemp: 53, lTemp: 25, imageURL: "sun.max.fill")
    
    static let DayWeatherData: [DailyWeather] = [Day0, Day1, Day2, Day3, Day4, Day5, Day6]
    
}
