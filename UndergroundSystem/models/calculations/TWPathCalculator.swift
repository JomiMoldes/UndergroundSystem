//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

protocol TWPathCalculator {

    func calculate(_ from:TWStation,_ to:TWStation) -> TWPathResult
    
}
