//
//  MockResponse.swift
//  CoffeeShopsTests
//
//  Created by Sujan Kanna on 3/25/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation
@testable import Coffee_Shops

class MockResponse {
    func nonEmptyvenueSearchResponse() -> MainResponse {
        let meta = Meta(code: 200, requestID: "5ac51d7e6a607143d811cecb")
        let response = Response(venues: nonEmptyVenues())
        return MainResponse(meta: meta, response: response)
    }
    
    func venue() -> Venue {
        let labeledLatlngs = LabeledLatLng(label: "display", lat: 40.72173744277209, lng: -73.98800687282996)
        let formattedAddress = ["180 Orchard St (btwn Houston & Stanton St)", "New York, NY 10002", "United States"]
        let location = Location(address: "180 Orchard St", crossStreet: "btwn Houston & Stanton St", lat: 40.72173744277209, lng: -73.98800687282996, labeledLatLngs: [labeledLatlngs], distance: 8, postalCode: "10002", cc: "US", city: "New York", state: "NY", country: "United States", formattedAddress: formattedAddress)
        let venuePage = VenuePage(id: "150747252")
        return Venue(id: "5642aef9498e51025cf4a7a5", name: "Mr. Purple", location: location, categories: [], venuePage: venuePage)
    }
    
    func nonEmptyVenues() -> [Venue] {
        let venue1 = venue()
        return [venue1]
    }
    
    func coffeeShops() -> [CoffeeShop] {
        return [CoffeeShop(coffeeShop: venue())]
    }
}

struct VenuesSearchResponse {
    static let nonEmptyVenuesResponse = """
{
  "meta": {
    "code": 200,
    "requestId": "5ac51d7e6a607143d811cecb"
  },
  "response": {
    "venues": [
      {
        "id": "5642aef9498e51025cf4a7a5",
        "name": "Mr. Purple",
        "location": {
          "address": "180 Orchard St",
          "crossStreet": "btwn Houston & Stanton St",
          "lat": 40.72173744277209,
          "lng": -73.98800687282996,
          "labeledLatLngs": [
            {
              "label": "display",
              "lat": 40.72173744277209,
              "lng": -73.98800687282996
            }
          ],
          "distance": 8,
          "postalCode": "10002",
          "cc": "US",
          "city": "New York",
          "state": "NY",
          "country": "United States",
          "formattedAddress": [
            "180 Orchard St (btwn Houston & Stanton St)",
            "New York, NY 10002",
            "United States"
          ]
        },
        "categories": [
          {
            "id": "4bf58dd8d48988d1d5941735",
            "name": "Hotel Bar",
            "pluralName": "Hotel Bars",
            "shortName": "Hotel Bar",
            "icon": {
              "prefix": "https://ss3.4sqi.net/img/categories_v2/travel/hotel_bar_",
              "suffix": ".png"
            },
            "primary": true
          }
        ],
        "venuePage": {
          "id": "150747252"
        }
      }
    ]
  }
}
"""
    
    static let emptyVenuesResponse = """
    {
      "meta": {
        "code": 200,
        "requestId": "5ac51d7e6a607143d811cecb"
      },
      "response": {
        "venues": []
      }
    }
    """
    
    static let invalidVenuesResponse = """
    {
      "meta": {
        "code": 200,
        "requestId": "5ac51d7e6a607143d811cecb"
      },
      "response": {
      }
    }
    """

}
