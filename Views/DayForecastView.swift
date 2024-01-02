//
//  DayForecastView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/29/23.
//

import SwiftUI
import Charts

let eps: Float = 0.0001
struct DayForecastView: View {
    
    @State var weatherKitManager: WeatherKitManager
    
    @State private var minTemp = 30;
    @State private var maxTemp = 75;
    
    private func calculateTemperatureRange() {
        let dayWeatherData = weatherKitManager.dayWeather
        
        if !dayWeatherData.isEmpty {
            
            let hTemp = dayWeatherData.map { Int(round($0.highTemperature.converted(to: .fahrenheit).value))}
            let lTemp = dayWeatherData.map { Int(round( $0.lowTemperature.converted(to: .fahrenheit).value))}

            if let maxTemperature = hTemp.max(),
               let minTemperature = lTemp.min() {
                self.minTemp = minTemperature - 10
                self.maxTemp = maxTemperature + 15
            } else {
                print("No data aavailable to determine max and min temperatures")
            }
        }
    }
    
    func addColorSegment(color: Color, startTmp: CGFloat, endTmp: CGFloat, low: CGFloat, high: CGFloat, gradientStops: inout [Gradient.Stop]) {
        
//        let minTmp: CGFloat = 0
//        let maxTmp: CGFloat = 125
        let localRange = high - low
        
        if low > endTmp || high < startTmp {
            return
        }

//        let segmentLow = max(low, startTmp)
        let segmentHigh = min(high, endTmp)

        // gradientStops.append(.init(color: color, location: (segmentLow - low) / localRange))
        gradientStops.append(.init(color: color, location: (segmentHigh - low) / localRange))
        
    }
    
    
    func temperatureColor(day: String, low: CGFloat, high: CGFloat) -> LinearGradient {

        // purple is from 0 to 20, 0.16
        // blue is from 20 to 45, 0.36
        // green is from 45 to 75, 0.6
        // yellow is from 75 to 95, 0.76
        // red is from 95 to 125, 1
        
        var gradientStops: [Gradient.Stop] = []
        
        addColorSegment(color: .purple, startTmp: 0, endTmp: 20, low: low, high: high, gradientStops: &gradientStops)
        addColorSegment(color: .blue, startTmp: 20, endTmp: 45, low: low, high: high, gradientStops: &gradientStops)
        addColorSegment(color: .green, startTmp: 46, endTmp: 75, low: low, high: high, gradientStops: &gradientStops)
        addColorSegment(color: .yellow, startTmp: 76, endTmp: 95, low: low, high: high, gradientStops: &gradientStops)
        addColorSegment(color: .red, startTmp: 96, endTmp: 125, low: low, high: high, gradientStops: &gradientStops)
        
        let gradient = Gradient(stops: gradientStops)
        
        let linearGradient = LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
        
        return linearGradient
    }
    
    func createDayForecastChartView() -> some View {
        VStack(alignment: .leading) {
            
            Text("Weekly Weather Forecast")
                .font(.system(size: 24))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("TitleUnderlineColor"))
            
            Chart {
                ForEach(weatherKitManager.dayWeather, id: \.date) { weatherData in
                    
                    let lTemp = Int(round(weatherData.lowTemperature.converted(to: .fahrenheit).value))
                    let hTemp = Int(round(weatherData.highTemperature.converted(to: .fahrenheit).value))
                    
                    let day = weatherData == weatherKitManager.dayWeather.first
                                ? "Today"
                                :  getAbbreviatedWeekDay(from: weatherData.date)
                    
                    
                    BarMark(x: .value("Day", day),
                            yStart: .value("Temp", lTemp),
                            yEnd: .value("Temp", hTemp))
                    .cornerRadius(10)
                    .foregroundStyle(temperatureColor(day: day, low: CGFloat(lTemp), high: CGFloat(hTemp)))
                    
                    
                    PointMark(x: .value("Day", day), y: .value("Temp", hTemp))
                    .symbol {
                        Image(systemName: "\(weatherData.symbolName).fill")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .offset(y: -50)
                    }
                    
                    PointMark(x: .value("Day", day), y: .value("Temp", hTemp))
                        .symbol {
                            Text("\(hTemp)°")
                                .offset(y: -17)
                                .foregroundStyle(.white)
                                .font(.system(size: 24, weight: .medium))
                        }
                    
                    PointMark(x: .value("Day", day), y: .value("Temp", lTemp))
                        .symbol {
                            Text("\(lTemp)°")
                                .offset(y: 20)
                                .foregroundStyle(.white)
                                .font(.system(size: 24, weight: .medium))
                        }
                }

            }
            .padding(.top)
            .chartYScale( domain: [minTemp, maxTemp] )
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        Text(String(format: "%d", value.as(Int.self) ?? 0))
                            .font(.system(size: 24, weight: .medium))
                    }
                    AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        Text(String(value.as(String.self) ?? "Today"))
                            .font(.system(size: 24, weight: .medium))
                    }
                }
            }
            .frame(minHeight: 400)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    func getAbbreviatedWeekDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        PanelView() {
            createDayForecastChartView()
        }
        .onAppear() {
            calculateTemperatureRange()
        }
        .onChange(of: weatherKitManager.dayWeather) { _, _ in
            calculateTemperatureRange()
        }
    }
}

//#Preview {
//    DayForecastView(dayWeatherData: DailyWeatherMockData.DayWeatherData)
//}


struct DayForecastView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherKitManager = WeatherKitManager()
        DayForecastView(weatherKitManager: weatherKitManager)
            .task {
                await weatherKitManager.getWeather()
            }
    }
}
