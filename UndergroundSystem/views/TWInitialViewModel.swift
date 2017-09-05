//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TWInitialViewModel {

    let fromInputYMultiplier:CGFloat = 0.6
    let toInputYMultiplier:CGFloat = 0.9
    let buttonYMultiplier:CGFloat = 0.8

    let updateConstraintsSubject = PublishSubject<Bool>()
    let pathFoundSubject = PublishSubject<TWPathResult>()

    let fromInputModel : TWInputStationViewModel
    let toInputModel : TWInputStationViewModel

    let calculator : TWPathCalculator

    var lastResult : TWPathResult?

    init(calculator:TWPathCalculator) {
        self.calculator = calculator
        fromInputModel = TWInputStationViewModel(provider:TWGlobalModels.sharedInstance.stationsProvider)
        toInputModel = TWInputStationViewModel(provider:TWGlobalModels.sharedInstance.stationsProvider)
        addObservers()
    }

    func searchTapped() -> Bool {
        guard let from = fromInputModel.selected,
                let to = toInputModel.selected else {
            return false
        }
        DispatchQueue.global(qos:.userInitiated).async {
            let pathResult = self.calculator.calculate(from, to)
            self.pathFoundSubject.onNext(pathResult)
            self.lastResult = pathResult
        }
        return true
    }

    func viewResized() {
        if let lastResult = lastResult {
            self.pathFoundSubject.onNext(lastResult)
        }
    }

    func createResultMViewModel() -> TWCityMapViewModel {
        let model = TWCityMapViewModel(provider:TWGlobalModels.sharedInstance.stationsProvider)
        return model
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil {
            updateConstraintsSubject.onNext(true)
        }
    }

}
