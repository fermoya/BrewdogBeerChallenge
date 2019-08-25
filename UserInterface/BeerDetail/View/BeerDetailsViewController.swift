//
//  BeerDetailViewController.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import Domain

class BeerDetailsViewController: UIViewController {

    private let viewModel: BeerDetailsViewModel
    
    var beer: Beer {
        get { return viewModel.beer }
        set { viewModel.beer = newValue }
    }
    
    init(viewModel: BeerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
