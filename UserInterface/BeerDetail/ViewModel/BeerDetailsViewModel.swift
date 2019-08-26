//
//  BeerDetailsViewModel.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain
import BusinessUseCases

class BeerDetailsViewModel {
    
    var beer: Beer! {
        didSet {
            recipeManager = recipeManagerBuilder.build(with: beer)
        }
    }
    
    private let recipeManagerBuilder: RecipeManagerBuilder
    private var recipeManager: RecipeManager!
    
    init(recipeManagerBuilder: RecipeManagerBuilder) {
        self.recipeManagerBuilder = recipeManagerBuilder
    }
    
    func bind(cell: RecipeStepTableViewCell, at indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!

        switch section {
        case .hops:
            cell.recipeStep = beer.ingredients.hops.map { $0 as RecipeStep }[indexPath.row]
        case .malts:
            cell.recipeStep = beer.ingredients.malts.map { $0 as RecipeStep }[indexPath.row]
        case .methods:
            cell.recipeStep = beer.brewMethod.recipe[indexPath.row]
        }
        
        let state = recipeManager.checkState(of: cell.recipeStep)
        cell.state = state
        
        cell.didTap = { [weak self] cell in
            self?.recipeStepDidTap(cell)
        }
        
    }
    
    private func recipeStepDidTap(_ cell: RecipeStepTableViewCell) {
        let step = cell.recipeStep!
        let state = recipeManager.checkState(of: step)
        switch state {
        case .idle:
            recipeManager.start(recipeStep: step) { (newState) in
                cell.state = newState
            }
        case .running:
            recipeManager.pause(recipeStep: step)
        case .paused:
            recipeManager.resume(recipeStep: step)
        default:
            return
        }
    }
    
}
