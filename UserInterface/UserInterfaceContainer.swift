//
//  UserInterfaceContainer.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import BusinessUseCases

protocol ViewControllerProvider: class {
    var viewController: UIViewController { get }
}

public final class UserInterfaceContainer {
    
    private var navigationController: UINavigationController
    private var businessUseCasesContainer: BusinessUseCasesContainer
    
    private(set) lazy var beerDetailContainer = BeerDetailsContainer(navigationController: navigationController)
    private(set) lazy var splashContainer = SplashContainer(beersContainer: beersContainer)
    private(set) lazy var beersContainer = BeersContainer(navigationController: navigationController, businessUseCasesContainer: businessUseCasesContainer, detailsContainer: beerDetailContainer)
    
    public init(navigationController: UINavigationController, businessUseCasesContainer: BusinessUseCasesContainer) {
        self.navigationController = navigationController
        self.businessUseCasesContainer = businessUseCasesContainer
    }
    
    public var initialViewController: UIViewController {
        return splashContainer.viewController
    }
    
}
