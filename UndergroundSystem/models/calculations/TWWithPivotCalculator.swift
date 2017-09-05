//
// Created by MIGUEL MOLDES on 11/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation

class TWWithPivotCalculator: TWPathCalculator {

    let provider : TWLinesAndStationsProvider

    init(provider:TWLinesAndStationsProvider) {
        self.provider = provider
    }

    func calculate(_ from:TWStation,_ to:TWStation) -> TWPathResult {
        if let commonLine = provider.sharedLine(from, to) {
            return calculateSameLine(from, to, commonLine)
        }

        let connections = connectionsByStation(from, connectionsToFilter: [])
        let pivot = Pivot(station:from, ids: [from.id], previousConnections: [from] + connections, ownConnections: connections)
        calculateDifferentLines(pivot:pivot, target:to)

        let stationsIds = bestPath
        let stations = stationsIds.map{ provider.stationById(id: $0) }.flatMap { $0 }
        let pathStations = parsePath(stations: stations)
        return TWPathResult(time: 1, price: 1, stations: pathStations)
    }

    private var bestPath = [Int]()

    private func calculateDifferentLines(pivot:Pivot, target:TWStation) {
        for connection in pivot.ownConnections {

            guard let sharedLine = provider.sharedLine(pivot.station, connection) else {
                fatalError("if it's a connection should share line")
            }

            if let sharedLineWithTarget = provider.sharedLine(connection, target) {
                let totalIds = pivot.ids +
                        stationsIdsInBetweenSameLine(from: pivot.station, to: connection, line: sharedLine) +
                        stationsIdsInBetweenSameLine(from: connection, to: target, line: sharedLineWithTarget)

                if totalIds.count < bestPath.count || bestPath.count == 0 {
                    bestPath = totalIds
                }
                continue
            }

            let ids = pivot.ids + stationsIdsInBetweenSameLine(from: pivot.station, to: connection, line: sharedLine)

            guard ids.count < bestPath.count || bestPath.count == 0 else { continue }

            let ownConnections = connectionsByStation(connection, connectionsToFilter: pivot.previousConnections)

            guard ownConnections.count > 0 else { continue }

            let connectionPivot = Pivot(station: connection,
                    ids: ids,
                    previousConnections: pivot.previousConnections + ownConnections,
                    ownConnections: ownConnections)

            calculateDifferentLines(pivot: connectionPivot, target: target)
        }
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

    private func connectionsByStation(_ from:TWStation, connectionsToFilter:[TWStation]) -> [TWStation] {
        let idsPreviousConnection = connectionsToFilter.map{ $0.id }
        var allConnections = [TWStation]()
        let lines = from.lines.map{ provider.lineBy(id: $0) }.flatMap { $0 }

        for line in lines {
            let connections = provider.connectionsForStationByLine(from, line: line)
            for connection in connections {
//                let distance = distanceBetweenTwoStationsInSameLine(from, connection, line)
                if idsPreviousConnection.index(of:connection.id) == nil {
//                    allConnections.append(NextStation(station: connection, line: line, distance: distance))
                    allConnections.append(connection)
                }
            }
        }
        return allConnections
    }

//    private func connectionsByStation(_ from:TWStation, previousConnections:[Int]) -> [NextStation] {
//        var allConnections = [NextStation]()
//        let lines = from.lines.map{ provider.lineBy(id: $0) }.flatMap { $0 }
//
//        for line in lines {
//            let connections = provider.connectionsForStationByLine(from, line: line)
//            for connection in connections {
//                let distance = distanceBetweenTwoStationsInSameLine(from, connection, line)
//                if previousConnections.index(of:connection.id) == nil {
//                    allConnections.append(NextStation(station: connection, line: line, distance: distance))
//                }
//            }
//        }
//        return allConnections.sorted{$0.distance < $1.distance}
//    }

    private func distanceBetweenTwoStationsInSameLine(_ from:TWStation, _ to:TWStation, _ line:TWLine) -> Int {
        let order = line.stationsOrder
        guard let fromIndex = order.index(of:from.id),
              let toIndex = order.index(of:to.id) else {
            fatalError("stations don't share this line")
        }

        return abs(toIndex - fromIndex)
    }
}

struct Pivot {

    let station : TWStation
    let ids: [Int]
    let previousConnections: [TWStation]
    let ownConnections: [TWStation]

    init(station:TWStation, ids: [Int], previousConnections: [TWStation], ownConnections: [TWStation]) {
        self.station = station
        self.ids = ids
        self.previousConnections = previousConnections
        self.ownConnections = ownConnections
    }
}
