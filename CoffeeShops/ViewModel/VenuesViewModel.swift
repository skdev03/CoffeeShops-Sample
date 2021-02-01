//
//  VenuesViewModel.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

/// Conforming to ObservableObject allows VenuesViewModel to @Published properties, which can be observed by SwiftUI.
class VenuesViewModel: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var dataSource: [CoffeeShop] = []
    
    private let venuesSearchable: VenuesSearchable
    private var disposables = Set<AnyCancellable>()
    
    init(venuesSearchable: VenuesSearchable, scheduler: DispatchQueue = DispatchQueue(label: "VenuesViewModel")) {
        self.venuesSearchable = venuesSearchable
        
        // This triggers a call to fetchVenues whenever a new user location is passed through.
        $currentLocation
            .debounce(for: .seconds(1), scheduler: scheduler)
            .sink(receiveValue: fetchVenues(atLocation:))
            .store(in: &disposables)
    }
    
    
    /// Fetches coffee shops for the current location. Maps the response to CoffeeShop model to be passed to the ContentView.
    /// Updates dataSource property in sink's receiveValue with new values, otherwise the datasource will be empty.
    func fetchVenues(atLocation location: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        venuesSearchable.venues(forLat: String(location.latitude), lng: String(location.longitude), query: "coffee")
            .map { response in
                response.response.venues.map(CoffeeShop.init)
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.dataSource = []
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] venues in
                guard let self = self else { return }
                self.dataSource = venues
        })
            .store(in: &disposables)
    }
}

