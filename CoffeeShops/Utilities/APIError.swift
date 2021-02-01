//
//  APIError.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/25/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation

enum APIError: Error {
    case parsing(description: String)
    case network(description: String)
}
