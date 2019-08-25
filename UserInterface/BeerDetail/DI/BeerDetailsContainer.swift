//
//  BeerDetailContainer.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

protocol BeerDetailsViewControllerProvider: ViewControllerProvider { }

final class BeerDetailsContainer {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var viewModel: BeerDetailsViewModel {
        return BeerDetailsViewModel()
    }
    
    var viewController: UIViewController {
        return BeerDetailsViewController(viewModel: viewModel)
    }
    
    var navigator: BeerDetailsNavigator {
        return BeerDetailsNavigator(navigationController: navigationController, viewControllerProvider: self)
    }
    
}

extension BeerDetailsContainer: BeerDetailsViewControllerProvider { }
