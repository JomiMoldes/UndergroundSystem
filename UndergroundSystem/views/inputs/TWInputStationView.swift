//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TWInputStationView : TWDesignableView {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet var tableView: UITableView!

    var model : TWInputStationViewModel! {
        didSet {
            self.setup()
            self.bind()
        }
    }

    let disposable = DisposeBag()
    
    override func xibSetup() {
        nibName = "TWInputStationView"
        super.xibSetup()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }

    func textHasChanged(_ textField:UITextField) {
        if let word = textField.text {
            model.textHasChanged(str: word)
        }
    }

    func resign() {
        inputTextField.resignFirstResponder()
    }

//private

    private func setup() {
        tableView.delegate = model
        tableView.dataSource = model

        tableView.register(UINib(nibName: "TWStationNameViewCell", bundle: nil), forCellReuseIdentifier: "stationNameViewCell")
        tableView.separatorColor = UIColor.clear

        inputTextField.addTarget(self, action: #selector(textHasChanged(_:)), for: .editingChanged)

    }

    private func bind() {
        model.updateTableSubject.asObservable()
            .subscribe(onNext:{
                [unowned self] _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .addDisposableTo(disposable)

        model.stationSelectedSubject.asObservable()
            .subscribe(onNext:{
                [unowned self] station in
                DispatchQueue.main.async {
                    self.inputTextField.text = station.name

                }
            })
            .addDisposableTo(disposable)
    }
}
