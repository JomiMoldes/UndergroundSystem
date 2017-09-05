//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWLoadJSONOperation {

    func execute(fileName:String, provider:TWLinesAndStationsProvider, completion:@escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = TWJSONLoader().load(fileName: fileName)
            let stations = TWStationsParser().parse(data)
            let lines = TWLinesParser().parse(data)
            provider.setup(stations: stations, lines: lines)
            completion()
        }

    }

}
