//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import CoreGraphics
import QuartzCore

protocol TWMetroLayerProtocol {

    func draw(frame:CGRect, model:TWCityMapViewModel)

    var layer : CAShapeLayer { get }

}
