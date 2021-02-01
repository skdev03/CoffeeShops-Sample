//
//  VenueSearchService.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import Foundation
import Combine

//https://api.foursquare.com/v2/venues/search
//client_id = WQYKKM1H5GIJB3FROHNVAB24NB10II5UPTKBQ1EOUV0THSSL
//client_secret = FZFIQFXZ4HETXOLBXEJIUDEA0AO2THTEUSHB13PIIMJK3QBR
//version:
//v=20180901

protocol VenuesSearchable {
    func venues(forLat lat: String, lng: String, query: String) -> AnyPublisher<MainResponse, APIError>
}

class VenuesSearchService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension VenuesSearchService: VenuesSearchable {
    func venues(forLat lat: String, lng: String, query: String) -> AnyPublisher<MainResponse, APIError> {
        let urlComponents = makeCoffeShopSearchComponents(with: lat, lng: lng, query: query)
        
        guard let url = urlComponents.url else {
            let error = APIError.network(description: "Could not create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url)
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                return .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { (data, response) in
                return decode(data)
            }
            .eraseToAnyPublisher()
    }
}

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
    let decoder = JSONDecoder()
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}


extension VenuesSearchService {
    struct VenuesSearchAPI {
        static let scheme = "https"
        static let host = "api.foursquare.com"
        static let path = "/v2/venues/search"
        static let clientId = "WQYKKM1H5GIJB3FROHNVAB24NB10II5UPTKBQ1EOUV0THSSL"
        static let clientSecret = "FZFIQFXZ4HETXOLBXEJIUDEA0AO2THTEUSHB13PIIMJK3QBR"
        static let version = "20180901"
    }
    
    func makeCoffeShopSearchComponents(with lat: String, lng: String, query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = VenuesSearchAPI.scheme
        components.host = VenuesSearchAPI.host
        components.path = VenuesSearchAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: VenuesSearchAPI.clientId),
            URLQueryItem(name: "client_secret", value: VenuesSearchAPI.clientSecret),
            URLQueryItem(name: "ll", value: "\(lat),\(lng)"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "v", value: VenuesSearchAPI.version),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        return components
    }
}


