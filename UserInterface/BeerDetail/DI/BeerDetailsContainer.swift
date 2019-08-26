//
//  BeerDetailContainer.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import BusinessUseCases

protocol BeerDetailsViewControllerProvider: ViewControllerProvider { }

final class BeerDetailsContainer {
    
    private let navigationController: UINavigationController
    private let businessUseCasesContainer: BusinessUseCasesContainer
    
    init(navigationController: UINavigationController, businessUseCasesContainer: BusinessUseCasesContainer) {
        self.navigationController = navigationController
        self.businessUseCasesContainer = businessUseCasesContainer
    }
    
    var viewModel: BeerDetailsViewModel {
        return BeerDetailsViewModel(recipeManagerBuilder: businessUseCasesContainer.recipeManagerBuilder)
    }
    
    var viewController: UIViewController {
        return BeerDetailsViewController(viewModel: viewModel)
    }
    
    var navigator: BeerDetailsNavigator {
        return BeerDetailsNavigator(navigationController: navigationController, viewControllerProvider: self)
    }
    
}

extension BeerDetailsContainer: BeerDetailsViewControllerProvider { }
