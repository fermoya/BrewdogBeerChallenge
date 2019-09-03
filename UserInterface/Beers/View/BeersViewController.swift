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

    @IBOutlet weak var leadingTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var topTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var heightTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var widthTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    private var viewModel: BeersViewModel
    private var beers: [Beer]! {
        didSet {
            beersTableView.reloadData()
        }
    }
    
    @IBOutlet weak var beersTableView: UITableView! {
        didSet {
            beersTableView.isHidden = true
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        setUpAnimation()
    }
    
    private func bindViewModel() {
        viewModel.didObserveNewItems = { [weak self] beers in
            guard let self = self else { return }
            self.beersTableView.isHidden = false
            let beersCount = self.beers?.count ?? 0
            guard beers.count > beersCount else { return }
            self.beers = beers
        }
    }
    
    private func setUpAnimation() {
        guard propertyAnimator.isEmpty else { return }
        
        propertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
        propertyAnimator.pausesOnCompletion = true
        
        let smallTextSize = (titleLabel.text! as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        
        takeSnapshot()
        
        titleLabel.isHidden = true
        
        widthTitleLabel.constant = smallTextSize.width
        heightTitleLabel.constant = smallTextSize.height
        leadingTitleLabel.constant = (UIScreen.main.bounds.width - smallTextSize.width) / 2
        topTitleLabel.constant = 0
        
        propertyAnimator.addAnimations { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        propertyAnimator.startAnimation()
        propertyAnimator.pauseAnimation()
    }
    
    // Text in titleLabel doesn't resize with the label
    private func takeSnapshot() {
        let labelImage = titleLabel.snapshotView(afterScreenUpdates: false)!
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelImage)
        
        view.addConstraints([
            labelImage.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            labelImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            labelImage.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            labelImage.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
            ])
        
        self.view.layoutIfNeeded()
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
