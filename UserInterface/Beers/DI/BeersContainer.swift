//
//  BeersContainer.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import BusinessUseCases

protocol BeersViewControllerProvider: ViewControllerProvider { }

final class BeersContainer {
    
    private let navigationController: UINavigationController
    private let businessUseCasesContainer: BusinessUseCasesContainer
    private let detailsContainer: BeerDetailsContainer
    
    var viewController: UIViewController {
        return BeersViewController(viewModel: viewModel)
    }
    
    var navigator: BeersNavigator {
        return BeersNavigator(navigationController: navigationController, viewControllerProvider: self)
    }
    
    var viewModel: BeersViewModel {
        return BeersViewModel(dataStorePager: businessUseCasesContainer.dataStorePager, detailsNavigator: detailsContainer.navigator)
    }
    
    init(navigationController: UINavigationController, businessUseCasesContainer: BusinessUseCasesContainer, detailsContainer: BeerDetailsContainer) {
        self.navigationController = navigationController
        self.businessUseCasesContainer = businessUseCasesContainer
        self.detailsContainer = detailsContainer
    }
}

extension BeersContainer: BeersViewControllerProvider { }
