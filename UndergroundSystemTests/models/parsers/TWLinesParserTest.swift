//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWLinesParserTest : XCTestCase {

    let sut = TWLinesParser()

    func testShouldReturnLines() {
        XCTAssertEqual(sut.parse(Data()).count, 0)

        let data = jsonLoader().load(fileName: "stations_test")
        let lines = sut.parse(data)
        XCTAssertEqual(lines.count, 5)

        let firstLine = lines[0]
        XCTAssertEqual(firstLine.name, "Blue line")
        XCTAssertEqual(firstLine.id, 1)
        XCTAssertEqual(firstLine.stationsOrder, [1,2,3,4,5,6,7,8,9,10])

        let otherLine = lines[2]
        XCTAssertEqual(otherLine.name, "Yellow line")
        XCTAssertEqual(otherLine.id, 3)
        XCTAssertEqual(otherLine.stationsOrder, [20,21,22,23,24,25,26])
    }


//MARK helpers

}
