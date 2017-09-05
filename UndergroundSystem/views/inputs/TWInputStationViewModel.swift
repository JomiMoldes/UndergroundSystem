//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TWInputStationViewModel : NSObject, UITableViewDelegate, UITableViewDataSource {

    let provider : TWLinesAndStationsProvider

    let updateTableSubject = PublishSubject<Bool>()
    let stationSelectedSubject = PublishSubject<TWStation>()

    var stationsFiltered = [TWStation]()

    var selected : TWStation?

    init(provider:TWLinesAndStationsProvider) {
        self.provider = provider
    }

    func textHasChanged(str:String) {
        self.provider.stationByWord(str, completion: {
            stations in
            self.stationsFiltered = stations
            self.updateTableSubject.onNext(true)
        })
    }


// Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = self.stationsFiltered.count == 0
        return self.stationsFiltered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationNameViewCell",for: indexPath as IndexPath) as! TWStationNameViewCell
        cell.setup(stationName: stationsFiltered[(indexPath as IndexPath).item].name)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = stationsFiltered[(indexPath as IndexPath).item]
        stationsFiltered = [TWStation]()
        updateTableSubject.onNext(true)
        stationSelectedSubject.onNext(self.selected!)
    }

}
