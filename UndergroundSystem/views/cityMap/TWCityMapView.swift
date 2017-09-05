//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TWCityMapView : UIView {

    var model : TWCityMapViewModel! {
        didSet {
            self.bind()
            self.createLayers()
        }
    }

    var metroLayers = [TWMetroLayerProtocol]()

    let disposable = DisposeBag()


    private func drawMetro() {
        if model.result != nil {
            for layer in self.metroLayers {
                layer.draw(frame: self.frame, model: model)
            }
        }
        let size = CGSize(width: self.frame.width, height: model.totalHeight + model.bottomMargin)
        self.frame = CGRect(origin:self.frame.origin, size: size)
    }


//Private

    private func bind() {
        model.drawSubject.asObservable()
            .subscribe(onNext:{
                [unowned self] _ in
                DispatchQueue.main.async{
                    self.drawMetro()
                }
            })
            .addDisposableTo(disposable)
    }

    private func createLayers() {
        metroLayers.append(TWMetroTitleLayer())
        metroLayers.append(TWMetroDirectionsLayer())
        metroLayers.append(TWMetroLineLayer())
        for metroLayer in metroLayers {
            self.layer.addSublayer(metroLayer.layer)
        }
    }

}
