//
//  WeatherKitManager.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/30/23.
//

import Foundation
import WeatherKit
import CoreLocation
import Observation
import MapKit

@Observable
class WeatherKitManager {
    
    var weather: Weather?
    var currentWeather: CurrentWeather?
    var dayWeather: [DayWeather] = []
    var hourWeather: [HourWeather] = []
    var weatherAlert: WeatherAlert?
    var weatherMetadata: WeatherMetadata?
    var city: String = "Location is not available"
    var attribution: WeatherAttribution?

    func getWeather(placemark: MKPlacemark? = nil) async {
        do {
            let currentTime = Date()
            let calendar = Calendar.current
            
            let latitude = placemark?.coordinate.latitude ?? 37.322998
            let longitude = placemark?.coordinate.longitude ?? -122.032181
            
            if let twelveHoursLater = calendar.date(byAdding: .hour, value: 11, to: currentTime),
               let aWeekLater = calendar.date(byAdding: .day, value: 6, to: currentTime)
            {
                let forecast = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude), including: .daily(startDate: currentTime, endDate: aWeekLater), .current, .alerts, .hourly(startDate: currentTime, endDate: twelveHoursLater))
                }.value
                let attrib = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.attribution
                }.value
                
                DispatchQueue.main.async {
                    self.currentWeather = forecast.1
                    self.dayWeather = forecast.0.forecast
                    self.weatherAlert = forecast.2?.first
                    self.hourWeather = forecast.3.forecast
                    self.fetchAddress()
                    self.attribution = attrib
                }

            }
            
        } catch {
            print("Error fetching weather: \(error)")
            fatalError("\(error)")
        }
    }
    
    
    var symbol: String {
        currentWeather?.symbolName ?? "xmark"
    }
    
    var temp: String {
        guard let temp = (currentWeather?.temperature) else {
            return "Loading Weather Data"
        }
        
        let convert = Int(round(temp.converted(to: .fahrenheit).value))
        return String(convert)
    }
    
    var apparentTemp: String {
        guard let temp = (currentWeather?.apparentTemperature) else {
            return "Loading Weather Data"
        }
        
        let convert = Int(round(temp.converted(to: .fahrenheit).value))
        return String(convert)
    }
    
    var condition: String {
        currentWeather?.condition.description ?? "Loading"
    }
    
    var dayHTemp: String {
        guard let temp = (dayWeather.first?.highTemperature) else {
            return "Loading Weather Data"
        }
        
        let convert = Int(round(temp.converted(to: .fahrenheit).value))
        return String(convert)
    }
    
    var dayLTemp: String {
        guard let temp = (dayWeather.first?.lowTemperature) else {
            return "Loading Weather Data"
        }
        
        let convert = Int(round(temp.converted(to: .fahrenheit).value))
        return String(convert)
    }
    
    var alert: String? {
        guard let alert = (weatherAlert?.summary) else { return nil }
        return alert
    }
    

    var humidity: String {
        guard let humidity = (currentWeather?.humidity) else {
            return "Humidity"
        }
        
        return String(Int(round(humidity * 100)))
    }
    
    var pressure: String {
        guard let pressure = (currentWeather?.pressure) else {
            return "Pressure"
        }
        
        let convert = Int(round(pressure.converted(to: .inchesOfMercury).value))
        return String(convert)
    }
    
    var uvIndex: String {
        guard let uvIndex = (currentWeather?.uvIndex) else {
            return "uvIndex"
        }
        return String(uvIndex.value)
    }
    
    var visibility: String {
        guard let visibility = (currentWeather?.visibility) else {
            return "visibility"
        }
        let convert = Int(round(visibility.converted(to: .miles).value))
        return String(convert)
    }
    
    var wind: String {
        guard let wind = (currentWeather?.wind) else {
            return "wind"
        }
        let convert = Int(round(wind.speed.converted(to: .milesPerHour).value))
        return String(convert)
    }
    
    func fetchAddress() {
        
        guard let location = currentWeather?.metadata.location else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
        
            if let placemark = placemarks?.first {
                self.city = placemark.locality?.description ?? self.city
            } else {
                print("No placemarks found")
            }
        }
    }
}
