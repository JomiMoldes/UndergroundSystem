//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

struct TWStationPath {

    let station : TWStation
    var nextStation : TWStation?
    let line : TWLine

    init(station:TWStation, line:TWLine) {
        self.station = station
        self.line = line
    }



}
