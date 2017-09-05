//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit

struct TWLine {

    let id : Int
    let name : String
    let stationsOrder : [Int]
    let color : UIColor

    init(id:Int, name:String, order:[Int], color:UIColor) {
        self.id = id
        self.name = name
        self.stationsOrder = order
        self.color = color
    }

}
