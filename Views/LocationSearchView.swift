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
    var isOpen: Bool = false
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }
    
    func search(query: String) {
        if query.isEmpty {
            self.searchResults = []
            self.placemarks = []
        } else {
            completer.queryFragment = query
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        self.searchResults = Array(completer.results.prefix(7))
        
        let group = DispatchGroup() // handle the async nature of multiple MKLocalSearch
        var placemarks: [MKPlacemark] = []

        for completion in self.searchResults {
            group.enter()
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if let placemark = response?.mapItems.first?.placemark {
                    placemarks.append(placemark)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.placemarks = placemarks
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location Search Error: \(error.localizedDescription)")
    }
}


struct LocationSearchView: View {
    
    var searchCompleter = SearchCompleter()
    @State private var searchText = ""
    @State private var debounceTask: DispatchWorkItem?
    @Binding var selectedPlacemark: MKPlacemark?
    
    @FocusState var isTextFieldFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: 32, height: 32)
                    .padding([.vertical, .leading])
                
                TextField("Enter city name", text: $searchText)
                    .focused($isTextFieldFocus)
                    .onChange(of: searchText) { preValue, newValue in
                        let input = String(newValue).trimmingCharacters(in: .whitespacesAndNewlines)
                        if !input.isEmpty {
                            debounceSearch(text: input)
                        }
                    }
                    .font(.system(size: 32))
                    .padding([.vertical, .trailing])
                    .onTapGesture {
                        isTextFieldFocus = true
                    }
                    
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("NewsWindowColor"), lineWidth: 2)
                    .opacity(isTextFieldFocus ? 1 : 0)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("TextField").opacity(0.3))
            )
            .padding(.top)
            .padding(.horizontal, 30)
            
            if searchCompleter.isOpen {
                List(searchCompleter.placemarks, id: \.self) { result in
                    Text(result.title ?? "No result")
                        .font(.system(size: 32))
                        .onTapGesture {
                            guard let title = result.title else { return }
                            // getCoordinatesFromCityName(cityName: title)
                            searchCompleter.isOpen = false
                            self.selectedPlacemark = result
                            searchText = title
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color("NightSky").opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .listStyle(GroupedListStyle())
            }
        }
        .padding()
        .onTapGesture {
            isTextFieldFocus = false
        }
    }
    
//    private func getCoordinatesFromCityName(cityName: String) {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
//            guard let placemarks = placemarks,
//                  let location = placemarks.first?.location 
//            else {
//                print("No location found")
//                return
//            }
//        }
//    }
    
    private func debounceSearch(text: String) {
        debounceTask?.cancel() // cancel previous task
        
        let task = DispatchWorkItem { [text] in
            searchCompleter.search(query: text)
        }
        
        // Schedule the new task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        debounceTask = task
        
        searchCompleter.isOpen = true
    }
    
}

#Preview {
    
    LocationSearchView(selectedPlacemark: .constant(nil))
}
