//
//  Datastore.swift
//  Repository
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain

public enum DataStoreError: Error, Equatable {
    case unknown(String)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case badGateway
    case unavailable
}

public protocol DataStore {
    func fetchItems(page: Int, completion: @escaping (Result<[Beer], DataStoreError>) -> Void)
}
