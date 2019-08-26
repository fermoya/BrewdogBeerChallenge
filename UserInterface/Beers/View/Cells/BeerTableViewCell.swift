//
//  BeerTableViewCell.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import Domain
import Kingfisher

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView! { didSet { icon.roundCorners() } }
    
    private var semiCircleLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.insertSublayer(semiCircleLayer, at: 0)
    }
    
    var beer: Beer! {
        didSet {
            updateUI()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        semiCircleLayer.fillColor = UIColor.darkGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        semiCircleLayer.path = UIBezierPath(ovalIn: CGRect(origin: .zero,
                                                           size: CGSize(width: 70, height: 70))).cgPath
        semiCircleLayer.bounds = semiCircleLayer.path!.boundingBox
        semiCircleLayer.position = CGPoint(x: bounds.width - 5, y: 5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
    }
    
    private func updateUI() {
        if let url = URL(string: beer.imageUrl) {
            icon.kf.setImage(with: url)
        }
        titleLabel.text = beer.name
        tagLineLabel.text = beer.tagLine
        descriptionLabel.text = beer.description
        abvLabel.text = "\(beer.abv)%"
    }
    
}
