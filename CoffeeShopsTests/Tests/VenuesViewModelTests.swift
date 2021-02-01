//
//  VenuesViewModelTests.swift
//  CoffeeShopsTests
//
//  Created by Sujan Kanna on 3/25/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import XCTest
import Combine
import CoreLocation
@testable import Coffee_Shops

class VenuesViewModelTests: XCTestCase {

    var service: MockVenuesSearchService!
    var viewModel: VenuesViewModel!
    var mockResponse: MockResponse!
    
    override func setUp() {
        mockResponse = MockResponse()
        service = MockVenuesSearchService()
        viewModel = VenuesViewModel(venuesSearchable: service)
    }

    override func tearDown() {
        mockResponse = nil
        service = nil
        viewModel = nil
    }

    func testNonEmptyValidVenuesSearch() {
        service.result = nonEmptyVenuesValidReponsePublisher()
        
        viewModel?.fetchVenues()
        
        let completedExpectation = expectation(description: "Completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let dataSource = viewModel!.dataSource
        let coffeeShops = mockResponse.coffeeShops()
        XCTAssertEqual(dataSource, coffeeShops)
    }
    
    func testEmptyValidVenuesSearch() {
        service.result = emptyVenuesValidReponsePublisher()
        
        viewModel?.fetchVenues()
        
        let completedExpectation = expectation(description: "Completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let dataSource = viewModel!.dataSource
        XCTAssertEqual(dataSource, [])
    }
    
    func testInvalidVenuesResponse() {
        service.result = invalidVenuesReponsePublisher()
        
        viewModel?.fetchVenues()
        
        let completedExpectation = expectation(description: "Completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let dataSource = viewModel!.dataSource
        XCTAssertEqual(dataSource, [])
    }
    
    func testUnableToFetchData() {
        let error = APIError.network(description: "Unable to fetch data")
        service.result = Fail(error: error).eraseToAnyPublisher()
        
        viewModel?.fetchVenues()
        
        let completedExpectation = expectation(description: "Completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let dataSource = viewModel!.dataSource
        XCTAssertEqual(dataSource, [])
    }
    
    func testUpdateCurrentLocation() {
        service.result = nonEmptyVenuesValidReponsePublisher()
        
        let location = CLLocationCoordinate2D()
        viewModel?.currentLocation = location
        
        let completedExpectation = expectation(description: "Completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let dataSource = viewModel!.dataSource
        let coffeeShops = mockResponse.coffeeShops()
        XCTAssertEqual(dataSource, coffeeShops)
    }
    
    func nonEmptyVenuesValidReponsePublisher() -> AnyPublisher<MainResponse, APIError> {
        return Just(Data(VenuesSearchResponse.nonEmptyVenuesResponse.utf8))
            .decode(type: MainResponse.self, decoder: JSONDecoder())
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func emptyVenuesValidReponsePublisher() -> AnyPublisher<MainResponse, APIError> {
        return Just(Data(VenuesSearchResponse.emptyVenuesResponse.utf8))
            .decode(type: MainResponse.self, decoder: JSONDecoder())
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func invalidVenuesReponsePublisher() -> AnyPublisher<MainResponse, APIError> {
        return Just(Data(VenuesSearchResponse.invalidVenuesResponse.utf8))
            .decode(type: MainResponse.self, decoder: JSONDecoder())
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
