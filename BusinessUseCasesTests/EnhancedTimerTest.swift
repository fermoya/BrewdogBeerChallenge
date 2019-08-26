//
//  BusinessUseCasesTests.swift
//  BusinessUseCasesTests
//
//  Created by Fernando Moya de Rivas on 26/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
@testable import BusinessUseCases

class EnhancedTimerTest: XCTestCase {

    func test_CountDown() {
        let timer = EnhancedTimer()
        let expectation = XCTestExpectation(description: "Countdown")
        
        timer.schedule(duration: 2) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_PauseTimer() {
        let timer = EnhancedTimer()
        let expectation = XCTestExpectation(description: "Countdown")
        
        timer.schedule(duration: 2) { _ in
            expectation.fulfill()
        }
        
        sleep(1)
        timer.pause()
        timer.resume()
        
        wait(for: [expectation], timeout: 4)
    }

}
