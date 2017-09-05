//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

@testable import UndergroundSystem

func jsonLoader() -> TWFileLoader {
    return TWJSONLoader()
}

func makeProvider() -> TWLinesAndStationsProvider {
    let data = jsonLoader().load(fileName: "stations_test")
    let stations = TWStationsParser().parse(data)
    let lines = TWLinesParser().parse(data)
    let provider = TWLinesAndStationsProviderFake()
    provider.setup(stations: stations, lines: lines)
    return provider
}
