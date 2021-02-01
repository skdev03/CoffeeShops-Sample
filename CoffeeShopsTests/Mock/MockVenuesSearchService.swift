//
//  MockVenuesSearchService.swift
//  CoffeeShopsTests
//
//  Created by Sujan Kanna on 3/26/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation
import Combine
@testable import Coffee_Shops

class MockVenuesSearchService: VenuesSearchable {
    var result: AnyPublisher<MainResponse, APIError>!
    
    func venues(forLat lat: String, lng: String, query: String) -> AnyPublisher<MainResponse, APIError> {
        return result.eraseToAnyPublisher()
    }
}
