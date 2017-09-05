//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit
import XCTest

@testable import UndergroundSystem

class TWInitialViewControllerTest : XCTestCase {

    func testInitiation() {
        let vc = makeSUT()
        XCTAssertNotNil(vc.view)
    }



// helpers

    private func makeSUT() -> TWInitialViewController {
        return TWInitialViewController(nibName: "TWInitialView", bundle: nil)
    }


}
