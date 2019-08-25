//
//  RepositoryTests.swift
//  RepositoryTests
//
//  Created by Fernando Moya de Rivas on 24/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import XCTest
import Mockingjay
@testable import Repository

class RepositoryTests: XCTestCase {

    private let dataStore = PunkApiWebservice()
    
    func test_fetchBeersDefaultPage() {
        
        let expectation = XCTestExpectation(description: "Download beers, default page")
        
        dataStore.fetchItems { result in
            if let items = try? result.get() {
                XCTAssert(items.count == 25, "Page size is incorrect")
                XCTAssertEqual(items.first!.id, 1, "Default page is incorrect")
                XCTAssertEqual(items.last!.id, 25, "Default page is incorrect")
                expectation.fulfill()
            } else {
                XCTFail("There was an error retrieving beers")
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_fetchBeersDefaultSecondPage() {
        
        let expectation = XCTestExpectation(description: "Download beers, second page")
        
        dataStore.fetchItems(page: 2) { result in
            if let items = try? result.get() {
                XCTAssert(items.count == 25, "Page size is incorrect")
                XCTAssertEqual(items.first!.id, 26, "Default page is incorrect")
                XCTAssertEqual(items.last!.id, 50, "Default page is incorrect")
                expectation.fulfill()
            } else {
                XCTFail("There was an error retrieving beers")
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }

    func test_fecthBeersBadRequest() {
        let expectation = XCTestExpectation(description: "Bad request fetching beers")
        stub(uri(PunkApiEndpoints.beers(3).url),
             http(400))
        
        dataStore.fetchItems(page: 3) { result in
            do {
                let _ = try result.get()
                XCTFail()
            } catch (let error) {
                let error = error as! DataStoreError
                XCTAssertEqual(error, DataStoreError.badRequest)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
