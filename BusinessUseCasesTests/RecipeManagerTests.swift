//
//  RecipeManagerTests.swift
//  BusinessUseCasesTests
//
//  Created by Fernando Moya de Rivas on 26/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import Domain
@testable import BusinessUseCases

class RecipeManagerTests: XCTestCase {
    
    let beer: Beer = {
        let fermentation = Fermentation(temperature: Measure(value: 60, measureType: .celsius))
        let mashTempertaure1 = MashTemperature(temperature: Measure(value: 30,
                                                                    measureType: .celsius),
                                               duration: 5)
        
        let mashTempertaure2 = MashTemperature(temperature: Measure(value: 40,
                                                                    measureType: .celsius),
                                               duration: 5)
        
        let mashTempertaure3 = MashTemperature(temperature: Measure(value: 20,
                                                                    measureType: .celsius))
        
        let brewMethod = BrewMethod(mashTemperatures: [mashTempertaure1, mashTempertaure2, mashTempertaure3],
                                    fermentation: fermentation)
        
        
        let malt1 = Malt(name: "Malt 1", amount: Measure(value: 2, measureType: .kilograms))
        let malt2 = Malt(name: "Malt 2", amount: Measure(value: 2, measureType: .kilograms))
        let malt3 = Malt(name: "Malt 3", amount: Measure(value: 2, measureType: .kilograms))
        
        let hop1 = Hop(name: "Hop 1", amount: Measure(value: 3, measureType: .kilograms), timing: .start, attribute: "")
        let hop2 = Hop(name: "Hop 2", amount: Measure(value: 3, measureType: .kilograms), timing: .middle, attribute: "")
        let hop3 = Hop(name: "Hop 3", amount: Measure(value: 3, measureType: .kilograms), timing: .middle, attribute: "")
        let hop4 = Hop(name: "Hop 4", amount: Measure(value: 3, measureType: .kilograms), timing: .end, attribute: "")
        
        let ingredients = Ingredients(malts: [malt1, malt2, malt3], hops: [hop1, hop2, hop3, hop4], yeast: "Fake Yeast")
        
        
        return Beer(id: 1, tagLine: "", name: "Fake Beer", abv: 4, description: "Fake Beer", imageUrl: "", brewMethod: brewMethod, ingredients: ingredients)
    }()
    
    func test_malts() {
        let manager = RecipeManager(beer: beer)
        
        let malts = beer.ingredients.malts.map { $0 as RecipeStep }
        manager.start(recipeStep: malts.last!) { (state) in
            XCTAssertTrue(state.isEqual(to: .done))
        }
        
        manager.start(recipeStep: malts.first!) { (state) in
            XCTAssertTrue(state.isEqual(to: .done))
        }
    }
    
    func test_maltsAndHops() {
        let manager = RecipeManager(beer: beer)
        
        let malts = beer.ingredients.malts.map { $0 as RecipeStep }
        let hops = beer.ingredients.hops.map { $0 as RecipeStep }
        
        let startHop = hops.first { $0.timing == .start }!
        let middleHop = hops.first { $0.timing == .middle }!
        let endHop = hops.first { $0.timing == .end }!
        
        manager.start(recipeStep: malts.last!) { (state) in
            XCTAssertTrue(state.isEqual(to: .done), "Malt should be DONE")
        }
        
        manager.start(recipeStep: middleHop) { (state) in
            XCTAssertTrue(state.isEqual(to: .idle), "Middle hop should be IDLE")
        }
        
        manager.start(recipeStep: startHop) { (state) in
            XCTAssertTrue(state.isEqual(to: .done), "Start hop should be DONE")
        }
        
        manager.start(recipeStep: endHop) { (state) in
            XCTAssertTrue(state.isEqual(to: .idle), "End hop should be IDLE")
        }
        
        manager.start(recipeStep: malts.first!) { (state) in
            XCTAssertTrue(state.isEqual(to: .done), "Malt should be DONE")
        }
    }
    
    func test_method() {
        
        let manager = RecipeManager(beer: beer)
        
        let steps = beer.brewMethod.recipe
        let step = steps.first { $0.duration != nil }!
        
        let expectation = XCTestExpectation(description: "Method should be paused")

        var state: RecipeStepState = .idle
        manager.start(recipeStep: step) { (newState) in
            state = newState
            
            if case RecipeStepState.done = state {
                expectation.fulfill()
                XCTAssertTrue(state.isEqual(to: manager.checkState(of: step)))
            }
        }
        
        if case .running = state {
            XCTAssertTrue(true, "Method should be running")
        } else {
            XCTFail()
        }
        
        manager.pause(recipeStep: step)
        XCTAssertTrue(state.isEqual(to: .paused), "Method should be paused")
        
        manager.resume(recipeStep: step)
        if case .running = state {
            XCTAssertTrue(true, "Method should be running")
        } else {
            XCTFail()
        }

        wait(for: [expectation], timeout: 6)
    }

}
