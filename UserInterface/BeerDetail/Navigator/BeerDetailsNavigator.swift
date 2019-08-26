//
//  BeerDetailNavigator.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class BeerDetailsNavigator {
    
    private let navigationController: UINavigationController
    private let viewControllerProvider: BeerDetailsViewControllerProvider
    
    init(navigationController: UINavigationController, viewControllerProvider: BeerDetailsViewControllerProvider) {
        self.navigationController = navigationController
        self.viewControllerProvider = viewControllerProvider
    }
    
    func startNavigation(binder: (UIViewController) -> Void) {
        let viewController = viewControllerProvider.viewController
        binder(viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
