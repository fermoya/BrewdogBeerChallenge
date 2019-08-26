//
//  UIView+Utils.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension UIView {
    
    func roundCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = max(bounds.width, bounds.height) / 2
    }
    
}
