//
//  VenueSearchResponse.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation

// MARK: - MainResponse
struct MainResponse: Codable {
    let meta: Meta
    let response: Response
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
    let requestID: String

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

// MARK: - Response
struct Response: Codable {
    let venues: [Venue]
}

// MARK: - CoffeeShop
struct Venue: Codable {
    let id, name: String
    let location: Location
    let categories: [Category]
    let venuePage: VenuePage?
}

// MARK: - Category
struct Category: Codable {
    let id, name, pluralName, shortName: String
    let icon: Icon
    let primary: Bool
}

// MARK: - Icon
struct Icon: Codable {
    let iconPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

// MARK: - Location
struct Location: Codable {
    let address, crossStreet: String?
    let lat, lng: Double
    let labeledLatLngs: [LabeledLatLng]
    let distance: Int
    let postalCode, cc, city, state: String?
    let country: String?
    let formattedAddress: [String]
}

// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    let label: String
    let lat, lng: Double
}

// MARK: - VenuePage
struct VenuePage: Codable {
    let id: String
}
