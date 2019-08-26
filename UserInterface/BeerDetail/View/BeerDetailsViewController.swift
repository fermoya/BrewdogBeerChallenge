//
//  BeerDetailViewController.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import Domain
import BusinessUseCases

enum Section: Int {
    case hops, malts, methods
}

class BeerDetailsViewController: UIViewController {

    private let viewModel: BeerDetailsViewModel
    
    @IBOutlet weak var heightConstraintDetailTableView: NSLayoutConstraint!
    @IBOutlet weak var detailsTableView: UITableView! {
        didSet {
            detailsTableView.delegate = self
            detailsTableView.register(UINib(nibName: RecipeStepTableViewCell.className,
                                            bundle: Bundle(for: type(of: self))),
                                      forCellReuseIdentifier: RecipeStepTableViewCell.className)
            detailsTableView.dataSource = self
        }
    }
    
    var beer: Beer {
        get { return viewModel.beer }
        set {
            viewModel.beer = newValue
            updateUI()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var abvLabel: UILabel! {
        didSet {
            abvLabel.roundCorners()
        }
    }
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    init(viewModel: BeerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = beer.name
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.darkGray.cgColor
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(origin: .zero,
                                                      size: CGSize(width: abvLabel.frame.width * 1.1,
                                                                   height: abvLabel.frame.width * 1.1))).cgPath
        shapeLayer.bounds = shapeLayer.path!.boundingBox
        shapeLayer.position = CGPoint(x: abvLabel.bounds.midX, y: abvLabel.bounds.midY)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        updateUI()
    }
    
    private func updateUI() {
        guard let _ = viewIfLoaded else { return }
        if let url = URL(string: beer.imageUrl) {
            icon.kf.setImage(with: url)
        }
        
        descriptionLabel.text = beer.description
        abvLabel.text = "\(beer.abv)%"
        titleLabel.text = beer.name
        tagLineLabel.text = beer.tagLine
        
        let headerHeight = detailsTableView.sectionHeaderHeight
        let rowHeight: CGFloat = 71
        
        let numberOfRows = CGFloat(beer.ingredients.hops.count + beer.ingredients.malts.count + beer.brewMethod.recipe.count)
        let numberOfSections: CGFloat = 3
        heightConstraintDetailTableView.constant = headerHeight * numberOfSections + numberOfRows * rowHeight
        view.layoutIfNeeded()
    }
}

extension BeerDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        header.backgroundColor = .white
        
        switch Section(rawValue: section)! {
        case .hops:
            header.text = "Hops"
        case .malts:
            header.text = "Malts"
        case .methods:
            header.text = "Mehods"
        }
        
        header.sizeToFit()
        return header
    }
    
}

extension BeerDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .hops:
            return beer.ingredients.hops.count
        case .malts:
            return beer.ingredients.malts.count
        case .methods:
            return beer.brewMethod.recipe.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeStepTableViewCell.className) as! RecipeStepTableViewCell
        viewModel.bind(cell: cell, at: indexPath)

        return cell
        
    }
    
}
