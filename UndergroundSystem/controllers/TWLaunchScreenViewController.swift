//
// Created by MIGUEL MOLDES on 9/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import UIKit

class TWLaunchScreenViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStations()
    }

    private func loadStations() {
        TWLoadJSONOperation().execute(fileName: "stations_test", provider: TWGlobalModels.sharedInstance.stationsProvider,
                completion: {
            self.done()
        })

    }

    private func done() {
        DispatchQueue.main.async {
            let vc = TWInitialViewController(nibName: "TWInitialView", bundle: nil)
            let initialModel = TWInitialViewModel(calculator: TWFastestPathCalculator(provider: TWGlobalModels.sharedInstance.stationsProvider))
            vc.customView.model = initialModel
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

}
