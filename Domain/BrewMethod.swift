//
//  Method.swift
//  Domain
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct BrewMethod {
    public var mashTemperatures: [MashTemperature]
    public var fermentation: Fermentation
    public var twist: String?
    
    public init(mashTemperatures: [MashTemperature], fermentation: Fermentation, twist: String? = nil) {
        self.mashTemperatures = mashTemperatures
        self.fermentation = fermentation
        self.twist = twist
    }
    
}

public struct MashTemperature {
    public var temperature: Measure
    public var duration: Int?
    
    public init(temperature: Measure, duration: Int? = nil) {
        self.temperature = temperature
        self.duration = duration
    }
}

public struct Fermentation {
    public var temperature: Measure
    
    public init(temperature: Measure) {
        self.temperature = temperature
    }
}
