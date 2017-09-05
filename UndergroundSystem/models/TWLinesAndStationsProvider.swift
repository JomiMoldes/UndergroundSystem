//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWLinesAndStationsProvider {

    var stations : [TWStation]!
    var lines : [TWLine]!
    private var stationsDic = [Int:TWStation]()
    private var linesDic = [Int:TWLine]()

    private var searchingQueue : DispatchQueue?

    func setup(stations:[TWStation], lines: [TWLine]) {
        self.stations = stations
        self.lines = lines
        parseByIds()
    }

    func lineBy(id:Int) -> TWLine? {
        return linesDic[id]
    }

    func stationById(id:Int) -> TWStation? {
        return stationsDic[id]
    }

    func sharedLine(_ from:TWStation,_ to: TWStation) -> TWLine? {
        let common = Set(from.lines).intersection(Set(to.lines))
        if let first = common.first {
            return lineBy(id: first)
        }
        return nil
    }

    func connectionsForStationByLine(_ station:TWStation, line:TWLine) -> [TWStation] {
        guard line.stationsOrder.index(of:station.id) != nil else {
            return []
        }
        return line.stationsOrder.flatMap{stationById(id: $0)}.filter{$0.id != station.id && $0.lines.count > 1}
    }

    func stationByWord(_ withStart: String, completion: @escaping([TWStation]) -> ()) {
        let startWord = withStart.lowercased()
        guard startWord.characters.count > 0 else {
            completion([TWStation]())
            return
        }

        if self.searchingQueue == nil {
            self.searchingQueue = DispatchQueue(label: "filtering_stations", qos: .background)
        }

        self.searchingQueue!.async {
            guard var list = self.stations else {
                completion([])
                return
            }
            
            list = list.filter {
                let stationName = $0.name
                let strQ = startWord.characters.count

                guard stationName.characters.count >= strQ else {
                    return false
                }

                let index = stationName.index(stationName.startIndex, offsetBy: strQ)
                let firstLetters = stationName.substring(to: index).lowercased()
                return firstLetters == startWord
            }
            list = list.sorted{
                $0.name < $1.name
            }

            completion(list)
        }
    }

    func destinationName(_ from:TWStation,_ to:TWStation) -> String {
        guard let sharedLine = sharedLine(from, to) else {
            return ""
        }
        let order = sharedLine.stationsOrder
        guard let fromIndex = order.index(of: from.id),
              let toIndex = order.index(of: to.id) else {
            return ""
        }

        if fromIndex < toIndex {
            return stationById(id: order[order.count - 1])!.name
        }
        return stationById(id: order[0])!.name
    }

// Private

    private func parseByIds() {
        for line in lines {
            linesDic[line.id] = line
        }
        for station in stations {
            stationsDic[station.id] = station
        }
    }

}
