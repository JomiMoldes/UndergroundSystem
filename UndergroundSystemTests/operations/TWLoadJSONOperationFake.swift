//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWLoadJSONOperationFake : TWLoadJSONOperation {

    var asyncExpectation : XCTestExpectation?

    override func execute(fileName: String, provider:TWLinesAndStationsProvider, completion: @escaping () -> Void) {
        super.execute(fileName: fileName, provider:provider, completion: {
            self.asyncExpectation?.fulfill()
        })
    }


}
