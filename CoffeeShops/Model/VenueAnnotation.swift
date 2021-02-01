//
//  VenueAnnotation.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation
import MapKit
import Contacts

final class VenueAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(venue: CoffeeShop) {
        self.title = venue.name
        self.subtitle = venue.address
        self.coordinate = CLLocationCoordinate2D(latitude: venue.lat, longitude: venue.lng)
    }
    
    func mapItem() -> MKMapItem {
      let addressDict = [CNPostalAddressStreetKey: subtitle ?? ""]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
