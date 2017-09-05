//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TWInitialView : UIView {
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var fromView: TWInputStationView!
    @IBOutlet weak var toView: TWInputStationView!
    
    @IBOutlet weak var buttonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var toStationYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromStationYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    let disposable = DisposeBag()

    var resultView : TWCityMapView!

    var model : TWInitialViewModel! {
        didSet {
            self.bind()
            self.setup()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let resultFrame = CGRect(x: 0.0, y: 0.0, width: self.scrollView.frame.width, height: resultView.frame.height)
        resultView.frame = resultFrame
        model.viewResized()
    }

//Private

    private func bind() {
        model.updateConstraintsSubject.asObservable()
                .subscribe(onNext:{ [unowned self] _ in
                    self.moveFieldsToTop()
                })
                .addDisposableTo(disposable)

        model.pathFoundSubject.asObservable()
                .subscribe(onNext:{ [unowned self] (result:TWPathResult) in
                    self.drawResult(result)
                })
                .addDisposableTo(disposable)
    }


    private func setup() {
        fromView.model = model.fromInputModel
        toView.model = model.toInputModel
        setupResultView()
    }

    private func setupResultView() {
        let resultFrame = CGRect(x: 0.0, y: 0.0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        resultView = TWCityMapView(frame: resultFrame)
        resultView.model = model.createResultMViewModel()
        self.scrollView.addSubview(resultView)
        scrollView.addConstraint(NSLayoutConstraint(item: resultView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }

    private func drawResult(_ result:TWPathResult) {
        DispatchQueue.main.async{
            self.resultView.model.result = result
        }
    }

    private func moveFieldsToTop() {
        let newToYConstraint = toStationYConstraint.constraintWithMultiplier(multiplier: model.toInputYMultiplier)
        toStationYConstraint.isActive = false
        self.addConstraint(newToYConstraint)
        toStationYConstraint = newToYConstraint

        let newFromYConstraint = fromStationYConstraint.constraintWithMultiplier(multiplier: model.fromInputYMultiplier)
        fromStationYConstraint.isActive = false
        self.addConstraint(newFromYConstraint)
        fromStationYConstraint = newFromYConstraint

        let newButtonYConstraint = buttonYConstraint.constraintWithMultiplier(multiplier: model.buttonYMultiplier)
        buttonYConstraint.isActive = false
        self.addConstraint(newButtonYConstraint)
        buttonYConstraint = newButtonYConstraint

        self.layoutIfNeeded()
    }

// IBActions

    @IBAction func searchTapped(_ sender: UIButton) {
        _ = model.searchTapped()
        fromView.resign()
        toView.resign()
    }
    

}
