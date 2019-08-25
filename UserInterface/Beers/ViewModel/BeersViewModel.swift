//
//  BeersViewModel.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain
import BusinessUseCases

class BeersViewModel {
    
    private let detailsNavigator: BeerDetailsNavigator
    private let dataStorePager: DataStorePager
    
    // Observers
    var didObserveNewItems: (([Beer]) -> Void)?
    var didObserveError: ((Error) -> Void)?
    
    init(dataStorePager: DataStorePager, detailsNavigator: BeerDetailsNavigator) {
        self.detailsNavigator = detailsNavigator
        self.dataStorePager = dataStorePager
    }
    
    func navigatoToDetail(of beer: Beer) {
        detailsNavigator.startNavigation { (viewController) in
            let detailViewController = viewController as? BeerDetailsViewController
            detailViewController?.beer = beer
        }
    }
    
    func fetchNewBeers() {
        dataStorePager.fetchNewItems { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.didObserveError?(error)
            case .success(let items):
                self?.didObserveNewItems?(items)
            }
        }
    }
    
}
