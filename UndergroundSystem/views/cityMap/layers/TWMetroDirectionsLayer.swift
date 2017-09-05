//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class TWMetroDirectionsLayer: TWMetroLayer {

    override func draw(frame:CGRect, model:TWCityMapViewModel) {
        super.draw(frame:frame, model:model)

        let textLayers = model.createLabels(boxWidth: frame.width)

        for label in textLayers {
            self.layer.addSublayer(label)
        }
    }

}