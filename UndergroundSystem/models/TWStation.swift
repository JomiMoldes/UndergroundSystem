//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

struct TWStation {

    let id : Int
    let name : String
    let lines : [Int]

    init(id:Int, name:String, lines:[Int]) {
        self.id = id
        self.name = name
        self.lines = lines
    }
}
