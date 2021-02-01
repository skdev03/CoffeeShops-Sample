//
//  CoffeeShopsView.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    // This will be wrapped into a dynamic property. SwiftUI subscribes to this object and invalidates the body of ContentView anytime a @Published property in VenuesViewModel changes.
    @ObservedObject var viewModel: VenuesViewModel
    
    init(viewModel: VenuesViewModel) {
      self.viewModel = viewModel
    }
    
    /// MapView uses $viewModel.dataSource to populate the coffee shops on the map.
    /// MapView passes current user location through $viewModel.currentLocation to automatically fetch new shops for that location.
    var body: some View {
        MapView(venues: $viewModel.dataSource, currentLocation: $viewModel.currentLocation)
            .edgesIgnoringSafeArea(.vertical)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: VenuesViewModel(venuesSearchable: VenuesSearchService()))
    }
}
