//
//  SplashContainer.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

final class SplashContainer {
    
    private var beersContainer: BeersContainer
    
    init(beersContainer: BeersContainer) {
        self.beersContainer = beersContainer
    }
    
    var viewModel: SplashViewModel {
        return SplashViewModel(beersNavigator: beersContainer.navigator)
    }
    
    var viewController: UIViewController {
        return SplashViewController(viewModel: viewModel)
    }
    
}
