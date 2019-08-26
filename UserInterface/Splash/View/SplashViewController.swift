//
//  SplashViewController.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.image = UIImage(named: "splash-image", in: Bundle.main, compatibleWith: nil)

        }
    }
    
    @IBOutlet weak var splashLogo: UIImageView! {
        didSet {
            splashLogo.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
    }
    
    private var viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: { [weak self] in
            self?.splashLogo.transform = .identity
        }) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                guard let self = self else { return }
                self.viewModel.navigateToBeers(from: self.splashLogo)
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.delegate = nil
    }
    
}
