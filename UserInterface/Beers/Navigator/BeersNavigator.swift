//
//  BeersNavigator.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

final class BeersNavigator: NSObject {
    
    private var navigationController: UINavigationController
    private var viewControllerProvider: BeersViewControllerProvider
    private var transition: RevealTransition!
    
    init(navigationController: UINavigationController, viewControllerProvider: BeersViewControllerProvider) {
        self.viewControllerProvider = viewControllerProvider
        self.navigationController = navigationController
    }
    
    func startRevealNavigation(from view: UIImageView) {
        transition = RevealTransition(view: view)
        navigationController.delegate = self
        navigationController.pushViewController(viewControllerProvider.viewController, animated: true)
    }
    
}

extension BeersNavigator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .push ? transition : nil
    }
    
}
