//
//  StepTableViewCell.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import BusinessUseCases

class RecipeStepTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.layer.borderWidth = 2
            checkButton.layer.cornerRadius = 5
            checkButton.layer.masksToBounds = true
        }
    }
    
    var didTap: ((RecipeStepTableViewCell) -> Void)?

    var recipeStep: RecipeStep! {
        didSet {
            nameLabel.text = recipeStep.name
            descriptionLabel.text = recipeStep.metaInfo
        }
    }
    
    var state: RecipeStepState! {
        didSet {
            switch state! {
            case .idle:
                checkButton.setTitle("IDLE", for: .normal)
                checkButton.setTitleColor(.lightGray, for: .normal)
                checkButton.layer.borderColor = UIColor.lightGray.cgColor
            case .paused:
                checkButton.setTitle("PAUSED", for: .normal)
                checkButton.setTitleColor(.orange, for: .normal)
                checkButton.layer.borderColor = UIColor.orange.cgColor
            case .running(let remainig):
                checkButton.setTitle("\(remainig) sec", for: .normal)
                checkButton.setTitleColor(.blue, for: .normal)
                checkButton.layer.borderColor = UIColor.blue.cgColor
            case .done:
                checkButton.setTitle("DONE", for: .normal)
                checkButton.setTitleColor(.green, for: .normal)
                checkButton.layer.borderColor = UIColor.green.cgColor
            }
        }
    }
    
    @IBAction func didTapCheckButton(_ sender: UIButton) {
        didTap?(self)
    }
    
}
