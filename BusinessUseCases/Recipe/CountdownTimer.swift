//
//  EnhancedTimer.swift
//  BusinessUseCases
//
//  Created by Fernando Moya de Rivas on 26/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class EnhancedTimer {
    
    weak var timer: Timer?
    
    private(set) var duration = 0
    private(set) var elapsedTime = 0
    var remainigTime: Int {
        return duration - elapsedTime
    }
    
    private var handler: ((RecipeStepState) -> Void)?
    
    func schedule(duration: Int, handler: ((RecipeStepState) -> Void)? = nil) {
        self.duration = duration
        self.handler = handler
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
            if self.elapsedTime >= duration {
                self.timer?.invalidate()
                handler?(.done)
            } else {
                handler?(.running(self.remainigTime))
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    func resume() {
        schedule(duration: duration, handler: handler)
    }
    
}
