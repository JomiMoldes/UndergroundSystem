//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit

class TWLinesParser {

    func parse(_ data: Data) -> [TWLine] {
        var lines = [TWLine]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let list = json as? [String: Any] {
                if let items = list["lines"] as? [Any] {
                    for line in items {
                        guard let info = line as? [String:Any] else { continue }

                        guard let id = info["id"] as? Int,
                              let name = info["name"] as? String,
                              let order = info["stationsOrder"] as? [Int],
                              let colors = info["color"] as? [Int] else { continue }


                        lines.append(TWLine(id: id, name: name, order: order, color: UIColor(red: CGFloat(colors[0]), green: CGFloat(colors[1]), blue: CGFloat(colors[2]), alpha: 1.0)))
                    }
                }
            }
        } catch _ {
        }
        return lines
    }

}
