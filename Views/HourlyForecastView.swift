//
//  HourlyForecastView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/27/23.
//

import SwiftUI
import Charts
import WeatherKit

struct HourlyForecastView: View {
    
    @State var weatherKitManager: WeatherKitManager
    
    @State private var minTemp = 30;
    @State private var maxTemp = 75;
    
    private func calculateTemperatureRange() {
        let hourWeatherData = weatherKitManager.hourWeather
        if !hourWeatherData.isEmpty {
            let temperatures = hourWeatherData.map { Int(round($0.temperature.converted(to: .fahrenheit).value)) }
            if let maxTemperature = temperatures.max(),
               let minTemperature = temperatures.min() {
                minTemp = minTemperature - 5
                maxTemp = maxTemperature + 10
            } else {
                print("No data aavailable to determine max and min temperatures")
            }
        }
    }
    
    func createHourlyForecastTrendChartView() -> some View {
        VStack(alignment: .leading) {
            Text("Hourly Weather Forecast")
                .font(.system(size: 24))
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("TitleUnderlineColor"))
            
            Chart {
                ForEach(weatherKitManager.hourWeather, id: \.date) { weatherData in
                    
                    let temperature = Int(round(weatherData.temperature.converted(to: .fahrenheit).value))
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: weatherData.date)
                    let currHour = calendar.component(.hour, from: Date())
                    let hourString = hour == currHour ? "Now" : String(hour % 12 + 1)
                
                    LineMark(x: .value("Hour", hourString),
                             y: .value("Temp", temperature))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.white)
                   
                    PointMark(x: .value("Hour", hourString),
                              y: .value("Temp", temperature))
                    .symbol {
                        ZStack {
                            Image(systemName: "\(weatherData.symbolName).fill")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .offset(y: -50)
                            Circle()
                                .frame(width: 7, height: 7)
                                .foregroundStyle(.white)
                            Text("\(temperature)°")
                                .font(.system(size: 24))
                                .offset(y: -20)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(.top)
            .chartYScale(
                domain: [minTemp, maxTemp]
            )
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel{
                        Text(String(format: "%d", value.as(Int.self) ?? 0))
                            .font(.system(size: 24, weight: .medium))
                    }
                    AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        Text(String(value.as(String.self) ?? "Now"))
                            .font(.system(size: 24, weight: .medium))
                    }
                }
            }
            .frame(minHeight: 300)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var body: some View {
        PanelView() {
            createHourlyForecastTrendChartView()
        }
        .onAppear() {
            calculateTemperatureRange()
        }
        .onChange(of: weatherKitManager.hourWeather) { _, _ in
            calculateTemperatureRange()
        }
    }
}

//#Preview {
//    HourlyForecastView(hourlyWeatherData: HourlyWeatherMockData.HourlyWeatherData)
//}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        HourlyForecastView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
