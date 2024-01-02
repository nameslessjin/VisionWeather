//
//  LocationSearchView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 1/2/24.
//

import SwiftUI
import MapKit
import Observation

@Observable
class SearchCompleter: NSObject, MKLocalSearchCompleterDelegate {
    var searchResults: [MKLocalSearchCompletion] = []
    var placemarks: [MKPlacemark] = []
    var completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }
    
    func search(query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        self.searchResults = Array(completer.results.prefix(7))
        
//        let group = DispatchGroup() // handle the async nature of multiple MKLocalSearch
//        var placemarks: [MKPlacemark] = []

//        for completion in self.searchResults {
//            group.enter()
//            let searchRequest = MKLocalSearch.Request(completion: completion)
//            let search = MKLocalSearch(request: searchRequest)
//            search.start { (response, error) in
//                if let placemark = response?.mapItems.first?.placemark {
//                    placemarks.append(placemark)
//                }
//                group.leave()
//            }
//        }
//        
//        group.notify(queue: .main) {
//            self.placemarks = placemarks
//            print(self.placemarks)
//        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location Search Error: \(error.localizedDescription)")
    }
}


struct LocationSearchView: View {
    
    var searchCompleter = SearchCompleter()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $searchText)
                .padding()
//                .onChange(of: searchText) { preValue, newValue in
//                    let input = String(newValue).trimmingCharacters(in: .whitespacesAndNewlines)
//                    searchCompleter.search(query: input)
//                }
//            List(searchCompleter.placemarks, id: \.self) { result in
//                Text(result.title ?? "No result")
//                    .onTapGesture {
//                        guard let title = result.title else { return }
//                        getCoordinatesFromCityName(cityName: title)
//                    }
//            }
        }
    }
    
    private func getCoordinatesFromCityName(cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location 
            else {
                print("No location found")
                return
            }
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
}

#Preview {
    LocationSearchView()
}
