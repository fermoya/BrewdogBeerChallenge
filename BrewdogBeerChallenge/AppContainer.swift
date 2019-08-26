//
//  AppCoordinator.swift
//  BrewdogBeerChallenge
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import UserInterface
import Repository
import BusinessUseCases
import UIKit

final class AppContainer {
    
    private(set) var window = UIWindow(frame: UIScreen.main.bounds)
    private(set) lazy var navigationController = UINavigationController()
    private(set) lazy var repositoryContainer = RepositoryContainer()
    private(set) lazy var businessUseCasesContainer = BusinessUseCasesContainer(repositoryContainer: repositoryContainer)
    private(set) lazy var userInterfaceContainer = UserInterfaceContainer(navigationController: navigationController, businessUseCasesContainer: businessUseCasesContainer)
    
    init() { }
    
    var rootViewController: UIViewController {
        let viewController = userInterfaceContainer.initialViewController
        navigationController.viewControllers = [viewController]
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    
}
