//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWGlobalModels {

    static let sharedInstance = TWGlobalModels()

    let stationsProvider : TWLinesAndStationsProvider!

    init() {
        self.stationsProvider = TWLinesAndStationsProvider()
    }

}
