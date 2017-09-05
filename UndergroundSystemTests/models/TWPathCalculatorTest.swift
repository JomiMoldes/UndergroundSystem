//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWPathCalculatorTest : XCTestCase {

    let timeUnit = 5
    let priceUnit = 1

    func testShouldReturnFastestPath() {
        let provider = makeProvider()

        for check in sameLineCheck {
            let from = provider.stationById(id: check[0])
            let to = provider.stationById(id: check[1])
            let time = check[2] * timeUnit
            let price = check[3] * priceUnit
            let result = makeSUT(provider: provider).calculate(from!, to!)
            XCTAssertEqual(result.price, price)
            XCTAssertEqual(result.time, time)
        }
    }

    func testShouldReturnFastestPathWithStationsInSameLine() {
        let provider = makeProvider()

        for check in sameLineWithStations {
            let from = provider.stationById(id: check["from"] as! Int)
            let to = provider.stationById(id: check["to"] as! Int)
            let stations = check["stations"] as! [Int]
            let result = makeSUT(provider: provider).calculate(from!, to!)
            XCTAssertEqual(result.stations.map{$0.station.id}, stations)
        }
    }

    func testShouldReturnFastestPathForStationsThatSharedConnections() {
        let provider = makeProvider()

        for check in sharedConnectionStations {
            let from = provider.stationById(id: check["from"] as! Int)
            let to = provider.stationById(id: check["to"] as! Int)
            let result = makeSUT(provider: provider).calculate(from!, to!)
            let price = (check["price"] as! Int) * priceUnit
            let stations = check["stations"] as! [Int]
            XCTAssertEqual(result.time, (stations.count - 1) * 5)
            XCTAssertEqual(result.stations.map{$0.station.id}, stations)
            XCTAssertEqual(result.price, price)
        }
    }

    func testShouldReturnFastestPathForStationsThatDoNotShareConnections() {
         let provider = makeProvider()

        for check in notSharedConnectionStations {
            let from = provider.stationById(id: check["from"] as! Int)
            let to = provider.stationById(id: check["to"] as! Int)
            let price = (check["price"] as! Int) * priceUnit
            let stations = check["stations"] as! [Int]
            let result = makeSUT(provider: provider).calculate(from!, to!)
            XCTAssertEqual(result.time, (stations.count - 1) * 5)
            XCTAssertEqual(result.stations.map{$0.station.id}, stations)
            XCTAssertEqual(result.price, price)
        }
    }



//MARK helpers

    private func makeSUT(provider:TWLinesAndStationsProvider) -> TWPathCalculator {
        return TWFastestPathCalculator(provider:provider)
    }


//Fake data

    let sameLineCheck = [
            [1,2,1,1],
            [1,3,2,2],
            [1,10,9,9],
            [10,1,9,9],
            [2,5,3,3],
            [6,6,0,0],
            [5,4,1,1],
            [1,11,1,1],
            [11,19,8,8],
            [33,9,3,3],
            [34,19,7,7]
    ]

    let sameLineWithStations = [
            [
                    "from": 1,
                    "to": 2,
                    "stations": [1, 2]
            ],
            [
                    "from": 1,
                    "to": 4,
                    "stations": [1, 2, 3, 4]
            ],
            [
                    "from": 1,
                    "to": 14,
                    "stations": [1, 11, 12, 13, 14]
            ],
            [
                    "from": 16,
                    "to": 13,
                    "stations": [16, 15, 14, 13]
            ]
    ]

    let sharedConnectionStations = [
            [
                    "from": 9,
                    "to": 12,
                    "stations": [9,8,7,6,5,4,3,2,1,11,12],
                    "price":11
            ],
            [
                    "from": 9,
                    "to": 11,
                    "stations": [9,8,7,6,5,4,3,2,1,11],
                    "price":10
            ],
            [
                    "from": 5,
                    "to": 12,
                    "stations": [5,4,3,2,1,11,12],
                    "price":7
            ],
            [
                    "from": 22,
                    "to": 31,
                    "stations": [22,21,20,31],
                    "price":4
            ],
            [
                    "from": 8,
                    "to": 18,
                    "stations": [8,9,36,37,24,38,19,18],
                    "price":9
            ]

    ]

    let notSharedConnectionStations = [
            [
                    "from": 5,
                    "to": 22,
                    "stations": [5,4,30,31,20,21,22],
                    "price":8
            ],
            [
                    "from": 8,
                    "to": 23,
                    "stations": [8,9,36,37,24,23],
                    "price":7
            ],
            [
                    "from": 27,
                    "to": 38,
                    "stations": [27,28,29,4,30,31,20,21,22,23,24,38],
                    "price":13
            ]
    ]

}
