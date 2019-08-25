//
//  Optinal+Utils.swift
//  Domain
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public extension Optional {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
