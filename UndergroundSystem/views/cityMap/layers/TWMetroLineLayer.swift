//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class TWMetroLineLayer : TWMetroLayer {

    override func draw(frame:CGRect, model:TWCityMapViewModel) {
        super.draw(frame:frame, model:model)

        let lines = model.stationsPaths(boxWidth: frame.width)
        for line in lines {
            self.layer.addSublayer(line)
        }

        let dots = model.stationsDots(boxWidth: frame.width)
        for dot in dots {
            self.layer.addSublayer(dot)
        }
    }

}
