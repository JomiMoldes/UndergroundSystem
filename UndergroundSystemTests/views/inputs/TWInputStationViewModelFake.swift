//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

@testable import UndergroundSystem


class TWInputStationViewModelFake : TWInputStationViewModel {

    var updateTableExpectation : XCTestExpectation?
    var searchExpectation : XCTestExpectation?

}
