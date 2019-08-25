//
//  PunkApiMappers.swift
//  Repository
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import Domain

extension Beer: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, name, abv, description, ingredients
        case tagLine = "tagline"
        case imageUrl = "image_url"
        case brewMethod = "method"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let id = try! container.decode(Int.self, forKey: .id)
        let name = try! container.decode(String.self, forKey: .name)
        let abv = try! container.decode(Float.self, forKey: .abv)
        let description = try! container.decode(String.self, forKey: .description)
        let tagLine = try! container.decode(String.self, forKey: .tagLine)
        let imageUrl = try! container.decode(String.self, forKey: .imageUrl)
        let brewMethod = try! container.decode(BrewMethod.self, forKey: .brewMethod)
        let ingredients = try! container.decode(Ingredients.self, forKey: .ingredients)
        
        self.init(id: id, tagLine: tagLine, name: name, abv: abv, description: description, imageUrl: imageUrl, brewMethod: brewMethod, ingredients: ingredients)
    }
}

extension Ingredients: Decodable {
    private enum CodingKeys: String, CodingKey {
        case malts = "malt"
        case hops
        case yeast
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let malts = try! container.decode([Malt].self, forKey: .malts)
        let hops = try! container.decode([Hop].self, forKey: .hops)
        let yeast = try! container.decode(String.self, forKey: .yeast)
        
        self.init(malts: malts, hops: hops, yeast: yeast)
    }
}

extension Malt: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, amount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let name = try! container.decode(String.self, forKey: .name)
        let amount = try! container.decode(Measure.self, forKey: .amount)
        
        self.init(name: name, amount: amount)
    }
}

extension Hop: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, amount, attribute
        case timing = "add"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let name = try! container.decode(String.self, forKey: .name)
        let amount = try! container.decode(Measure.self, forKey: .amount)
        let attribute = try! container.decode(String.self, forKey: .attribute)
        let timing = try! container.decode(String.self, forKey: .timing)
        
        self.init(name: name, amount: amount, timing: Timing(rawValue: timing) ?? .start, attribute: attribute)
    }
}

extension BrewMethod: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case fermentation, twist
        case mashTemperatures = "mash_temp"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        let mashTemperatures = try! container.decode([MashTemperature].self, forKey: .mashTemperatures)
        let fermentation = try! container.decode(Fermentation.self, forKey: .fermentation)
        let twist = try? container.decode(String.self, forKey: .twist)

        self.init(mashTemperatures: mashTemperatures, fermentation: fermentation, twist: twist)
    }
}

extension MashTemperature: Decodable {
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case duration
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let temperature = try! container.decode(Measure.self, forKey: .temperature)
        let duration = try? container.decode(Int?.self, forKey: .duration)
        self.init(temperature: temperature, duration: duration)
    }
}

extension Fermentation: Decodable {
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let temperature = try! container.decode(Measure.self, forKey: .temperature)
        self.init(temperature: temperature)
    }
}

extension Measure: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case value
        case measureType = "unit"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let value = try! container.decode(Float.self, forKey: .value)
        let measureType = try! container.decode(String.self, forKey: .measureType)
        
        self.init(value: value, measureType: MeasureType(rawValue: measureType) ?? .none)
    }
}

