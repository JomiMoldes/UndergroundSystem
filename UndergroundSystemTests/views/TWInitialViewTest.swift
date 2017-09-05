//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCTest

@testable import UndergroundSystem

class TWInitialViewTest : XCTestCase  {

    var view : TWInitialView!

    override func setUp() {
        super.setUp()
        view = Bundle.main.loadNibNamed("TWInitialView", owner: self)?[0] as! TWInitialView
        view.model = TWInitialViewModelFake(calculator: TWFastestPathCalculator(provider:TWLinesAndStationsProviderFake()))
    }

    func testView() {
        XCTAssertNotNil(view.model)
    }

    func testNewConstraints() {
        let asyncExpectation = expectation(description: "keyboard will show")
        (view.model as! TWInitialViewModelFake).keyboardExpectation = asyncExpectation
        NotificationCenter.default.post(name: .UIKeyboardWillShow , object:nil, userInfo: [UIKeyboardFrameBeginUserInfoKey:CGRect(x: 1, y: 1, width: 1, height: 1)])

        waitForExpectations(timeout: 1) {
            error in
            if error != nil {
                XCTFail()
            }

            XCTAssertTrue(true)
            XCTAssertEqual(floor(self.view.model.buttonYMultiplier * 10),floor(self.view.buttonYConstraint.multiplier * 10))
        }
    }


}
