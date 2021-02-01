//
//  CoffeeShop.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation

struct CoffeeShop {
    private let coffeeShop: Venue
    
    var id: String {
        return coffeeShop.id
    }
    
    var name: String {
        return coffeeShop.name
    }
    
    var lat: Double {
        return coffeeShop.location.lat
    }
    
    var lng: Double {
        return coffeeShop.location.lng
    }
    
    var address: String? {
        return coffeeShop.location.formattedAddress.joined(separator: "\n")
    }
    
    init(coffeeShop: Venue) {
        self.coffeeShop = coffeeShop
    }
}

extension CoffeeShop: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
