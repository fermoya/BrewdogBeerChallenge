//
//  Ingredient.swift
//  Domain
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct Ingredients {
    public var malts: [Malt]
    public var hops: [Hop]
    public var yeast: String
    
    public init(malts: [Malt], hops: [Hop], yeast: String) {
        self.malts = malts
        self.hops = hops
        self.yeast = yeast
    }
}

public struct Malt {
    public var name: String
    public var amount: Measure
    
    public init(name: String, amount: Measure) {
        self.name = name
        self.amount = amount
    }
}

public enum Timing: String {
    case start, middle, end
}

public struct Hop {
    public var name: String
    public var amount: Measure
    public var timing: Timing
    public var attribute: String
    
    public init(name: String, amount: Measure, timing: Timing, attribute: String) {
        self.name = name
        self.amount = amount
        self.timing = timing
        self.attribute = attribute
    }
}
