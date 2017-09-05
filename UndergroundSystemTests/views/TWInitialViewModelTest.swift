//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import XCTest

@testable import UndergroundSystem

class TWInitialViewModelTest : XCTestCase {

    var provider : TWLinesAndStationsProviderFake!

    let disposable = DisposeBag()

    func testShouldNotSearch() {
        let sut = makeSUT()

        XCTAssertFalse(sut.searchTapped())
    }

    func testSearchResult() {
        let sut = makeSUT()
        
        let firstStation = self.provider.stationById(id: 1)
        let secondStation = self.provider.stationById(id: 2)
        sut.fromInputModel.selected = firstStation
        sut.toInputModel.selected = secondStation

        let calculationExpectation = expectation(description: "calculate")
        var pathResult : TWPathResult?

        sut.pathFoundSubject.asObservable()
            .subscribe(onNext: {
                result in
                pathResult = result
                calculationExpectation.fulfill()
            })
            .addDisposableTo(disposable)

        _ = sut.searchTapped()
        
        waitForExpectations(timeout: 12.3) {
            error in
            if error != nil {
                XCTFail()
                return
            }

            XCTAssertNotNil(pathResult)
        }
    }


/// helpers

    private func makeSUT() -> TWInitialViewModelFake {
        self.provider = makeProvider() as! TWLinesAndStationsProviderFake
        return TWInitialViewModelFake(calculator: TWFastestPathCalculator(provider:provider))
    }

}
