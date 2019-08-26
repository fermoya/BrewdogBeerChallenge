//
//  PunkWebservice.swift
//  Repository
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain
import Alamofire

public class PunkApiWebservice: DataStore {
    public func fetchItems(page: Int = 1, completion: @escaping (Swift.Result<[Beer], DataStoreError>) -> Void) {
        
        let page = page <= 0 ? 1 : page
        let endpoint: PunkApiEndpoints = .beers(page)
        let url = URL(string: endpoint.url)!
        request(url).validate().responseJSON { [weak self] (dataResponse) in
            guard let self = self else { return }
            let error = self.findErrors(in: dataResponse)
            guard error == nil else { return completion(.failure(error!)) }
            guard let data = dataResponse.data else {
                return completion(.failure(.unknown("Empty response")))
            }
            
            let beers = try! JSONDecoder().decode([Beer].self, from: data)
            
            completion(.success(beers))
        }
    }
    
    private func findErrors<T>(in dataResponse: DataResponse<T>) -> DataStoreError? {
        guard let error = dataResponse.error else { return nil }
        
        if let httpCode = dataResponse.response?.statusCode {
            return processHttpErrorResponse(with: httpCode)
        } else {
            return .unknown(error.localizedDescription)
        }
        
    }
    
    private func processHttpErrorResponse(with code: Int) -> DataStoreError {
        let error: DataStoreError
        switch code {
        case 400:
            error = .badRequest
        case 401:
            error = .unauthorized
        case 403:
            error = .forbidden
        case 404:
            error = .notFound
        case 500:
            error = .internalServerError
        case 502:
            error = .badGateway
        case 503:
            error = .unavailable
        default:
            error = .unknown("HTTP code \(code)")
        }
        return error
    }
    
}
