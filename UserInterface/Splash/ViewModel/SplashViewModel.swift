//
//  SplashViewModel.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class SplashViewModel {
    
    private var beersNavigator: BeersNavigator
    
    init(beersNavigator: BeersNavigator) {
        self.beersNavigator = beersNavigator
    }
    
    func navigateToBeers(from view: UIImageView) {
        beersNavigator.startRevealNavigation(from: view)
    }
    
}
