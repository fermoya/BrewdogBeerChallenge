//
//  BrewedItem.swift
//  Domain
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct Beer {
    public var id: Int
    public var tagLine: String
    public var name: String
    public var abv: Float
    public var description: String
    public var imageUrl: String
    public var brewMethod: BrewMethod
    public var ingredients: Ingredients
    
    public init(id: Int, tagLine: String, name: String, abv: Float, description: String, imageUrl: String, brewMethod: BrewMethod, ingredients: Ingredients) {
        self.id = id
        self.tagLine = tagLine
        self.name = name
        self.abv = abv
        self.description = description
        self.imageUrl = imageUrl
        self.brewMethod = brewMethod
        self.ingredients = ingredients
    }
    
}
