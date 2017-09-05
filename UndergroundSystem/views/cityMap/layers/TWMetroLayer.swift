//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import QuartzCore

class TWMetroLayer : NSObject, TWMetroLayerProtocol {

    let layer = CAShapeLayer()

    func draw(frame:CGRect, model:TWCityMapViewModel) {
        layer.frame = frame
        clean()
    }

    func clean() {
        layer.path = nil
        layer.mask = nil
        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                subLayer.removeFromSuperlayer()
            }    
        }

    }

}
