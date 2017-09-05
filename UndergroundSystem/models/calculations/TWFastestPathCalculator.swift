//
// Created by MIGUEL MOLDES on 8/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWFastestPathCalculator : TWPathCalculator {

    let provider : TWLinesAndStationsProvider

    init(provider:TWLinesAndStationsProvider) {
        self.provider = provider
    }


    func calculate(_ from:TWStation,_ to:TWStation) -> TWPathResult {
        if let commonLine = provider.sharedLine(from, to) {
            return calculateSameLine(from, to, commonLine)
        }

        return calculateDifferentLines(from, to)
    }

    private func calculateSameLine(_ from:TWStation,_ to:TWStation, _ line:TWLine) -> TWPathResult {
        let order = line.stationsOrder
        guard order.index(of:from.id) != nil &&
            order.index(of:to.id) != nil else {
            fatalError("stations don't share this line")
        }

        let stationsIds = [from.id] + stationsIdsInBetweenSameLine(from: from, to: to, line: line)
        let stations = stationsIds.map{ provider.stationById(id: $0) }.flatMap { $0 }
        let pathStations = parsePath(stations: stations)
        return TWPathResult(time: (stationsIds.count - 1) * 5, price: (stationsIds.count - 1) * 1, stations:pathStations)
    }

    private func stationsIdsInBetweenSameLine(from:TWStation, to:TWStation, line:TWLine) -> [Int] {
        let order = line.stationsOrder
        guard let fromIndex = order.index(of:from.id),
              let toIndex = order.index(of:to.id) else {
            fatalError("stations don't share this line")
        }

        var stationsIds = [Int]()
        if fromIndex > toIndex {
            stationsIds = Array(order[toIndex...fromIndex]).reversed()
        } else {
            stationsIds  = Array(order[fromIndex...toIndex])
        }
        stationsIds.removeFirst()
        return stationsIds
    }

    private func orderByMatches(_ fromConnections:[NextStation],_ toConnections:[NextStation]) -> [NextStation] {
        let matches = sharedConnections(fromConnections, toConnections)

        return fromConnections.sorted{ from, to in
            let id = from.station.id
            for match in matches {
                if match.station.id == id {
                    return true
                }
            }
            return false
        }
    }

    private func sharedConnections(_ fromConnections:[NextStation],_ toConnections:[NextStation]) -> [NextStation] {
        let matches = toConnections.filter {
            for station in fromConnections {
                if station.station.id == $0.station.id {
                    return true
                }
            }
            return false
        }

        return matches
    }

    private func connectionsByStation(_ from:TWStation) -> [NextStation] {
        var allConnections = [NextStation]()
        let lines = from.lines.map{ provider.lineBy(id: $0) }.flatMap { $0 }

        for line in lines {
            let connections = provider.connectionsForStationByLine(from, line: line)
            for connection in connections {
                let distance = distanceBetweenTwoStationsInSameLine(from, connection, line)
                allConnections.append(NextStation(station: connection, line: line, distance: distance))
            }
        }
        return allConnections.sorted{$0.distance < $1.distance}
    }

    private func distanceBetweenTwoStationsInSameLine(_ from:TWStation, _ to:TWStation, _ line:TWLine) -> Int {
        let order = line.stationsOrder
        guard let fromIndex = order.index(of:from.id),
              let toIndex = order.index(of:to.id) else {
            fatalError("stations don't share this line")
        }

        return abs(toIndex - fromIndex)
    }

    private func calculateDifferentLines(_ from:TWStation,_ to:TWStation) -> TWPathResult {

        let toConnections = connectionsByStation(to)
        let fromConnections = orderByMatches(connectionsByStation(from), toConnections)

        var combinations = 0
        var stationsAmount = 0
        var stationsIds = [Int]()

        var lastConnection:NextStation?
        for station in fromConnections {
            var q = station.distance
            let stationsIdsToConnection = stationsIdsInBetweenSameLine(from: from, to: station.station, line: station.line)
            if let sharedLine = provider.sharedLine(station.station, to) {
                q += distanceBetweenTwoStationsInSameLine(station.station, to, sharedLine)
                if q < stationsAmount || stationsAmount == 0 {
                    stationsAmount = q
                    stationsIds = [from.id] + stationsIdsToConnection
                    lastConnection = station
                    combinations = 1
                }
                continue
            }
            var ownFromConnections = connectionsByStation(station.station)
            ownFromConnections = orderByMatches(ownFromConnections, toConnections)

            for connection in ownFromConnections {
                var q2 = connection.distance
                var total = q + q2
                if total >= stationsAmount && stationsAmount > 0 {
                    continue
                }
                let totalIds = stationsIdsInBetweenSameLine(from: station.station, to: connection.station, line: connection.line)
                if let sharedLine = provider.sharedLine(connection.station, to) {
                    q2 += distanceBetweenTwoStationsInSameLine(connection.station, to, sharedLine)
                    total = q + q2
                    if total < stationsAmount || stationsAmount == 0 {
                        stationsAmount = total
                        stationsIds = [from.id] + stationsIdsToConnection + totalIds
                        lastConnection = connection
                        combinations = 2
                    }
                    continue
                }
            }
        }

        if let lastConnection = lastConnection,
           let sharedLine = provider.sharedLine(lastConnection.station, to) {
            let idsToFinalStation = stationsIdsInBetweenSameLine(from: lastConnection.station, to: to, line: sharedLine)
            stationsIds = stationsIds + idsToFinalStation
        }
        let stations = stationsIds.map{ provider.stationById(id: $0) }.flatMap { $0 }
        let pathStations = parsePath(stations: stations)
        return TWPathResult(time: (stationsIds.count - 1) * 5, price: (stationsIds.count - 1 + combinations)  * 1, stations: pathStations)
    }

    private func parsePath(stations:[TWStation]) -> [TWStationPath] {
        var pathStations = [TWStationPath]()
        for i in 0..<stations.count {
            let station:TWStation = stations[i]
            var sharedLine : TWLine!
            var nextStation : TWStation?
            if i < stations.count - 1{
                nextStation = stations[i + 1]
                sharedLine = provider.sharedLine(station, nextStation!)
            } else if i > 0 {
                let previousStation = stations[i - 1]
                sharedLine = provider.sharedLine(station, previousStation)
            } else {
                sharedLine = provider.lineBy(id: station.lines.first!)
            }

            var pathStation = TWStationPath(station: station, line: sharedLine)
            if let nextStation = nextStation {
                pathStation.nextStation = nextStation
            }
            pathStations.append(pathStation)
        }
        return pathStations
    }

}

struct NextStation {

    var station : TWStation
    var line : TWLine
    var distance : Int
    var path = [TWStation]()

    init(station:TWStation, line:TWLine, distance:Int){
        self.station = station
        self.line = line
        self.distance = distance
    }

}
