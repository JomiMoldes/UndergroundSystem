//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWLoadJSONOperationTest : XCTestCase {

    func testLoadJSON() {
        let provider = TWLinesAndStationsProvider()
        let asyncExpectation = expectation(description: "json loaded")
        let sut = makeSUT()
        sut.asyncExpectation = asyncExpectation
                
        sut.execute(fileName: "stations_test", provider: provider, completion: {})

        waitForExpectations(timeout: 10) {
            error in
            if error != nil {
                XCTFail()
            }

            XCTAssertEqual(provider.stations.count, 38)
            XCTAssertEqual(provider.lines.count, 5)
        }
    }


    private func makeSUT() -> TWLoadJSONOperationFake {
        return TWLoadJSONOperationFake()
    }

}
