//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWInitialViewModelFake : TWInitialViewModel {

    var keyboardExpectation : XCTestExpectation?

    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        keyboardExpectation?.fulfill()
    }


}
