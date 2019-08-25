//
//  Endpoints.swift
//  Repository
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

enum PunkApiEndpoints {
    case beers(Int)
    
    private var host: String { return "https://api.punkapi.com/v2" }
    private var path: String {
        switch self {
        case .beers:
            return "/beers"
        }
    }
    
    private var queryItems: String {
        switch self {
        case .beers(let page):
            return "?page=\(page)"
        }
    }
    
    var url: String {
        return host + path + queryItems
    }
}
