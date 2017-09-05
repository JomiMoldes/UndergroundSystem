import Foundation
import XCTest

@testable import UndergroundSystem

class TWStationsParserTest : XCTestCase {

    let sut = TWStationsParser()

    func testShouldLoadStations() {
        let stations2 = sut.parse(Data())
        XCTAssertEqual(stations2.count, 0)

        let data = jsonLoader().load(fileName: "stations_test")
        let stations = sut.parse(data)
        XCTAssertEqual(stations.count, 38)

        let firstStation = stations[0]
        XCTAssertEqual(firstStation.name, "East end")
        XCTAssertEqual(firstStation.id, 1)
        XCTAssertEqual(firstStation.lines, [1,2])

        let otherStation = stations[3]
        XCTAssertEqual(otherStation.name, "City Centre")
        XCTAssertEqual(otherStation.id, 4)
        XCTAssertEqual(otherStation.lines, [1,4])
    }


//MARK helpers

}