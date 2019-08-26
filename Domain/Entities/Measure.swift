//
//  Amount.swift
//  Domain
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public enum MeasureType: String {
    case grams, kilograms, litres, celsius, none
}

public struct Measure {
    public var value: Float
    public var measureType: MeasureType
    
    public init(value: Float, measureType: MeasureType) {
        self.value = value
        self.measureType = measureType
    }
}
