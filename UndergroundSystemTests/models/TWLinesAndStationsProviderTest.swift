import Foundation
import XCTest

@testable import UndergroundSystem

class TWLinesAndStationsProviderTest : XCTestCase {

    

    func testShouldProvideStations() {
        let sut = makeSUT()
        XCTAssertEqual(sut.stations.count, 38)
        XCTAssertEqual(sut.lines.count, 5)
    }

    func testShouldProvideLineById() {
        let sut = makeSUT()

        let line = sut.lineBy(id:1)
        XCTAssertEqual(line?.name, "Blue line")

        let line5 = sut.lineBy(id:5)
        XCTAssertEqual(line5?.name, "Red line")

        let lineNil = sut.lineBy(id:0)
        XCTAssertNil(lineNil)
    }

    func testShouldReturnStationById() {
        let sut = makeSUT()
        let station1 = sut.stationById(id:1)
        XCTAssertEqual(station1?.name, "East end")

        let stationNil = sut.stationById(id: 0)
        XCTAssertNil(stationNil)

        let station38 = sut.stationById(id: 38)
        XCTAssertEqual(station38?.name, "Trinity lane")
    }

    func testShouldCheckIfStationsShareLine() {
        let sut = makeSUT()

        let line1 = sut.sharedLine(sut.stationById(id: 1)!, sut.stationById(id: 3)!)
        XCTAssertEqual(line1?.id, 1)

        let line2 = sut.sharedLine(sut.stationById(id: 1)!, sut.stationById(id: 9)!)
        XCTAssertEqual(line2?.id, 1)

        let line3 = sut.sharedLine(sut.stationById(id: 1)!, sut.stationById(id: 12)!)
        XCTAssertEqual(line3?.id, 2)
    }

    func testShouldReturnsConnectionsInStationLines() {
        let sut = makeSUT()

        var station = sut.stationById(id: 2)
        var line = sut.lineBy(id: 1)
        var connections = sut.connectionsForStationByLine(station!, line:line!)
        XCTAssertEqual(connections.count, 3)

        station = sut.stationById(id: 1)
        line = sut.lineBy(id: 1)
        connections = sut.connectionsForStationByLine(station!, line:line!)
        XCTAssertEqual(connections.count, 2)

        station = sut.stationById(id: 9)
        line = sut.lineBy(id: 1)
        connections = sut.connectionsForStationByLine(station!, line:line!)
        XCTAssertEqual(connections.count, 2)
        XCTAssertEqual(connections[0].id, 1)
        XCTAssertEqual(connections[1].id, 4)

    }

    func testShouldReturnStationByWord1() {
        let sut = makeSUT()
        sut.searchExpectation = expectation(description: "search expectation")

        let expected = ["Boxers street","Boxing avenue"]
        sut.stationByWord("Box", completion: { _ in })

        waitForExpectations(timeout: 1) {
            error in
            if error != nil {
                XCTFail()
            }
            if let stationsFound = sut.stationsFound {
                XCTAssertFalse(stationsFound.isEmpty)
                for i in 0..<stationsFound.count {
                    XCTAssertEqual(stationsFound[i].name, expected[i])
                }
            }
        }
    }

    func testShouldReturnStationByWord2() {
        let sut = makeSUT()
        sut.searchExpectation = expectation(description: "search expectation")
        sut.stationByWord("", completion: { _ in })

        waitForExpectations(timeout: 1) {
            error in
            if error != nil {
                XCTFail()
            }
            if let found = sut.stationsFound {
                XCTAssertTrue(found.isEmpty)
            }
        }
    }

    func testShouldReturnStationByWord3() {
        let sut = makeSUT()
        sut.searchExpectation = expectation(description: "search expectation")
        sut.stationByWord("A", completion: { _ in })

        waitForExpectations(timeout: 1) {
            error in
            if error != nil {
                XCTFail()
            }
            if let found = sut.stationsFound {
                XCTAssertTrue(found.isEmpty)
            }
        }
    }

    func testShouldReturnStationByWord4() {
        let sut = makeSUT()
        sut.searchExpectation = expectation(description: "search expectation")

        let expected = ["Neo lane","Newton bath tub", "North Park"]
        sut.stationByWord("N", completion: { _ in })

        waitForExpectations(timeout: 1) {
            error in
            if error != nil {
                XCTFail()
            }
            if let stationsFound = sut.stationsFound {
                XCTAssertFalse(stationsFound.isEmpty)
                for i in 0..<stationsFound.count {
                    XCTAssertEqual(stationsFound[i].name, expected[i])
                }
            }
        }

    }


//MARK helpers

    private func makeSUT() -> TWLinesAndStationsProviderFake {
        let data = jsonLoader().load(fileName: "stations_test")
        let stations = TWStationsParser().parse(data)
        let lines = TWLinesParser().parse(data)
        let provider = TWLinesAndStationsProviderFake()
        provider.setup(stations: stations, lines: lines)
        return provider
    }

}
