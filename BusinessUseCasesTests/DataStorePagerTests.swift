//
//  DataStorePagerTests.swift
//  BusinessUseCasesTests
//
//  Created by Fernando Moya de Rivas on 26/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import Repository
@testable import BusinessUseCases

class DataStorePagerTests: XCTestCase {
    
    func test_paging() {
        let container = RepositoryContainer()
        let dataStore = container.dataStore
        let pager = DataStorePager(dataStore: dataStore)
        
        let expectation = XCTestExpectation(description: "Download 2 pages")
        
        pager.fetchNewItems { _ in
            pager.fetchNewItems { result in
                if let items = try? result.get() {
                    XCTAssert(items.count == 50, "Page size is incorrect")
                    expectation.fulfill()
                } else {
                    XCTFail("There was an error retrieving beers")
                }
            }
        }
        
        wait(for: [expectation], timeout: 6)
    }

}
