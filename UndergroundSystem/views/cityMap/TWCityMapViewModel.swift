//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import QuartzCore

class TWCityMapViewModel {

    let drawSubject = PublishSubject<Bool>()
    let stationsSeparation : CGFloat = 30.0

    let labelLeftMargin : CGFloat = 50.0
    let labelRightMargin : CGFloat = 10.0
    let topMargin : CGFloat = 10.0
    let bottomMargin : CGFloat = 10.0
    let circlePointsSize : CGFloat = 10.0
    let separationBetweenLabels : CGFloat = 10.0
    let titleLabelMargin : CGFloat = 10.0
    let linePathWidth : CGFloat = 2.0

    var totalHeight:CGFloat = 0
    var titleHeight:CGFloat = 0

    var allYPositions = [CGFloat]()

    var result : TWPathResult? {
        didSet {
            self.drawResult()
        }
    }

    let provider : TWLinesAndStationsProvider

    init(provider:TWLinesAndStationsProvider) {
        self.provider = provider
    }

    func pathSteps() -> [String] {
        guard let result = result else {
            return []
        }

        var names = [String]()
        let stations = result.stations
        var lastLine : TWLine?
        for i in 0..<stations.count {
            let station:TWStationPath = stations[i]

            if i == 0 {
                names.append("Starting at " + station.station.name)
                lastLine = station.line
                continue
            }
            if i == stations.count - 1 {
                names.append("Get off at " + station.station.name)
                continue
            }
            if lastLine != nil && lastLine?.id != station.line.id {
                names.append("Switch to " + station.line.name + " at station " + station.station.name + " direction to " + provider.destinationName(station.station, station.nextStation!) )
                lastLine = station.line
                continue
            }
            names.append(station.station.name)
            lastLine = station.line
        }
        return names

    }

    func timeAndPrice(boxWidth:CGFloat) -> CATextLayer? {
        guard let result = result else {
            return nil
        }
        let maxWidth = boxWidth - (labelRightMargin * 2)
        let pos = CGPoint(x: labelRightMargin, y: topMargin)
        let description = "Time: \(result.time) mins, price: $\(result.price)"
        let label = CATextLayer()
        label.isWrapped = true

        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any,
                          NSForegroundColorAttributeName: UIColor.white
        ]
        let attString = NSAttributedString(string: description, attributes: attributes)

        let stringHeight = attString.heightWithConstrainedWidth(width: maxWidth)
        label.frame = CGRect(origin: pos, size: CGSize(width: maxWidth, height: stringHeight))

        label.string = attString
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        label.alignmentMode = kCAAlignmentCenter

        titleHeight = stringHeight
        return label
    }

    func createLabels(boxWidth:CGFloat) -> [CATextLayer] {
        let maxWidth = boxWidth - labelLeftMargin - labelRightMargin
        var layers = [CATextLayer]()
        let descriptions = pathSteps()

        var yPos:CGFloat = topMargin + titleHeight  + titleLabelMargin
        let alignmentMode = kCAAlignmentLeft

        allYPositions = [CGFloat]()

        for description in descriptions {
            let pos = CGPoint(x: labelLeftMargin, y: yPos)

            let label = CATextLayer()
            label.isWrapped = true

            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any,
                              NSForegroundColorAttributeName: UIColor.white
            ]
            let attString = NSAttributedString(string: description, attributes: attributes)

            let totalHeight = attString.heightWithConstrainedWidth(width: maxWidth)

            allYPositions.append(yPos + (totalHeight / 2))

            yPos += totalHeight + separationBetweenLabels

            label.frame = CGRect(origin: pos, size: CGSize(width: maxWidth, height: totalHeight))

            label.string = attString
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            label.alignmentMode = alignmentMode
            layers.append(label)
        }
        self.totalHeight = yPos - separationBetweenLabels
        return layers
    }

    func stationsDots(boxWidth: CGFloat) -> [CAShapeLayer] {
        var dots = [CAShapeLayer]()
        if let stations = result?.stations {
            let positions = allYPositions
            for i in 0..<stations.count {
                let station: TWStationPath = stations[i]
                let position = positions[i]

                var point = CGPoint(x: labelLeftMargin / 2, y: position)
                point.x -= circlePointsSize / 2
                point.y -= circlePointsSize / 2

                let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: circlePointsSize, height: circlePointsSize))).cgPath

                let pointLayer = CAShapeLayer()
                pointLayer.path = circle
                pointLayer.fillColor = station.line.color.cgColor
                pointLayer.strokeColor = station.line.color.cgColor
                dots.append(pointLayer)
            }
        }
        return dots
    }

    func stationsPaths(boxWidth: CGFloat) -> [CAShapeLayer] {
        var lines = [CAShapeLayer]()
        if let stations = result?.stations {
            let positions = allYPositions
            for i in 0..<stations.count {
                let station: TWStationPath = stations[i]
                let position = positions[i]

                let point = CGPoint(x: labelLeftMargin / 2, y: position)

                let path = UIBezierPath()

                var nextPoint:CGPoint?
                if i < stations.count - 1 {
                    nextPoint = CGPoint(x: labelLeftMargin / 2, y: positions[i + 1])
                }

                path.contractionFactor = CGFloat(0.7)
                path.move(to:point)
                if let nextPoint = nextPoint {
                    path.addBezierThrough(points: [nextPoint])
                }

                let layer = CAShapeLayer()
                layer.lineWidth = linePathWidth
                layer.strokeColor = station.line.color.cgColor
                layer.path = path.cgPath
                layer.lineCap = kCALineCapRound
                lines.append(layer)
            }
        }
        return lines

    }

    private func drawResult() {
        drawSubject.onNext(true)
    }
    

}
