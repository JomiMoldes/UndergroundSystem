//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWJSONLoader : TWFileLoader {

    func load(fileName:String) -> Data {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .alwaysMapped) {
                return data
            }
        }
        return Data()

    }

}
