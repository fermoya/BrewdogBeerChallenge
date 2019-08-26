//
//  RecipeManager.swift
//  BusinessUseCases
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain

fileprivate class CookingStep {
    var recipeStep: RecipeStep
    var state: RecipeStepState = .idle {
        didSet {
            handler?(state)
        }
    }
    var timer = EnhancedTimer()
    var handler: ((RecipeStepState) -> Void)?
    
    init(recipeStep: RecipeStep) {
        self.recipeStep = recipeStep
    }
}

public enum RecipeStepState {
    case idle
    case running(Int)
    case paused
    case done
    
    func isEqual(to state: RecipeStepState) -> Bool {
        switch (self, state) {
        case (.done, .done), (.idle, .idle), (.paused, .paused):
            return true
        case (.running(let remaining1), .running(let remaining2)):
            return remaining1 == remaining2
        default:
            return false
        }
    }
}

extension Timing: Comparable {
    
    public static func < (lhs: Timing, rhs: Timing) -> Bool {
        guard lhs != rhs else { return false }
        guard lhs != .none else { return false }
        guard rhs != .none else { return true }
        return lhs == .start || (lhs == .middle && rhs == .end)
    }
    
}

public final class RecipeManagerBuilder {
    
    public func build(with beer: Beer) -> RecipeManager {
        return RecipeManager(beer: beer)
    }
    
}

public final class RecipeManager {
    
    private var cookingSteps: [CookingStep] = []
    
    init(beer: Beer) {
        let steps = beer.ingredients.recipe + beer.brewMethod.recipe
        self.cookingSteps = steps.map { CookingStep(recipeStep: $0) }
    }
    
    public func start(recipeStep: RecipeStep, handler: ((RecipeStepState) -> Void)? = nil) {
        let cookingStep = getCookingStep(for: recipeStep)
        
        guard case RecipeStepState.idle = cookingStep.state else {
            return
        }
        
        cookingStep.handler = handler
        
        switch recipeStep.type {
        case .malt:
            cookingStep.state = .done
        case .hop:
            let stepsToGo = cookingSteps.filter {
                if case RecipeStepState.done = $0.state { return false }
                else { return true }
                }.filter { $0.recipeStep.timing < recipeStep.timing }
            cookingStep.state = stepsToGo.isEmpty ? .done : .idle
        case .method:
            guard let duration = recipeStep.duration else {
                cookingStep.state = .done
                return
            }
            
            cookingStep.state = .running(duration)
            cookingStep.timer.schedule(duration: duration) { state in
                cookingStep.state = state
            }
        case .twist:
            cookingStep.state = .done
        }
    }
    
    public func checkState(of recipeStep: RecipeStep) -> RecipeStepState {
        let cookingStep = getCookingStep(for: recipeStep)
        return cookingStep.state
    }
    
    public func pause(recipeStep: RecipeStep) {
        let cookingStep = getCookingStep(for: recipeStep)
        cookingStep.state = .paused
        cookingStep.timer.pause()
    }
    
    public func resume(recipeStep: RecipeStep) {
        let cookingStep = getCookingStep(for: recipeStep)
        cookingStep.state = .running(cookingStep.timer.remainigTime)
        cookingStep.timer.resume()
    }
    
    private func getCookingStep(for step: RecipeStep) -> CookingStep {
        return cookingSteps.first { $0.recipeStep.name == step.name && $0.recipeStep.metaInfo == step.metaInfo }!
    }
    
}
