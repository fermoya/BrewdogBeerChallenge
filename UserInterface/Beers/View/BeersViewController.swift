//
//  BeersViewController.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import Domain

class BeersViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraintBeersTableView: NSLayoutConstraint!
    private var viewModel: BeersViewModel
    private var beers: [Beer]! {
        didSet {
            beersTableView.reloadData()
        }
    }
    
    @IBOutlet weak var beersTableView: UITableView! {
        didSet {
            beersTableView.register(UINib(nibName: BeerTableViewCell.className,
                                          bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: BeerTableViewCell.className)
            beersTableView.delegate = self
            beersTableView.dataSource = self
        }
    }
    
    private var propertyAnimator: UIViewPropertyAnimator!
    
    init(viewModel: BeersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        viewModel.fetchNewBeers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpAnimation()
    }
    
    private func bindViewModel() {
        viewModel.didObserveNewItems = { [weak self] beers in
            guard let self = self else { return }
            let beersCount = self.beers?.count ?? 0
            guard beers.count > beersCount else { return }
            self.beers = beers
        }
    }
    
    private func setUpAnimation() {
        guard propertyAnimator.isEmpty else { return }
        
        propertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
        
        let label = UILabel(frame: .zero)
        label.text = titleLabel.text
        label.font = titleLabel.font
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.sizeToFit()
        
        let destination = CGPoint(x: (UIScreen.main.bounds.width - label.frame.width) / 2,
                                  y: (view.safeAreaInsets.top + 44 - label.frame.height) / 2)
        
        let transform = CGAffineTransform(translationX: destination.x - titleLabel.frame.origin.x,
                                          y: destination.y - titleLabel.frame.origin.y)
            .concatenating(CGAffineTransform(scaleX: label.bounds.width / titleLabel.bounds.width,
                                             y: label.bounds.height / titleLabel.bounds.height))
        
        self.topConstraintBeersTableView.constant = view.safeAreaInsets.top + 60
        propertyAnimator.addAnimations { [weak self] in
            self?.titleLabel.transform = transform
            self?.view.layoutSubviews()
        }
        
        propertyAnimator.startAnimation()
        propertyAnimator.pauseAnimation()
    }
}

extension BeersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.isEmpty ? 0 : beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beersTableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.className, for: indexPath) as! BeerTableViewCell
        cell.beer = beers[indexPath.row]
        
        if indexPath.row == beers.count - 1 {
            viewModel.fetchNewBeers()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}


extension BeersViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = max(0, min(1, scrollView.contentOffset.y / 200))
        propertyAnimator.fractionComplete = progress
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = beers[indexPath.row]
        viewModel.navigatoToDetail(of: beer)
    }
    
}
