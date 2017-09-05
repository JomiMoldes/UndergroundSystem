//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class TWMetroTitleLayer: TWMetroLayer {

    override func draw(frame:CGRect, model:TWCityMapViewModel) {
        super.draw(frame:frame, model:model)

        if let title = model.timeAndPrice(boxWidth: frame.width) {
            self.layer.addSublayer(title)
        }
    }
}
