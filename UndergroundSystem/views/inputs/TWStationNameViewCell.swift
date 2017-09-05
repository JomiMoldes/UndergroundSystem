//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit

class TWStationNameViewCell : UITableViewCell {

    @IBOutlet weak var label:UILabel!

    func setup(stationName:String) {
        self.label.text = stationName
    }

}
