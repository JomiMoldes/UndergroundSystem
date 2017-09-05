//
// Created by MIGUEL MOLDES on 10/4/17.
// Copyright (c) 2017 MiguelMoldes. All rights reserved.
//

import Foundation
import XCTest

@testable import UndergroundSystem

class TWInputStationViewTest : XCTestCase {


    var provider : TWLinesAndStationsProviderFake!

    func testView() {
        let view = makeSUT()

        
//        view.tableView = UITableView(frame:view.frame)
//        view.tableView.dataSource = view.model
        XCTAssertNotNil(view.model)
    }


//helpers

    private func makeSUT() -> TWInputStationView {
        let view = TWInputStationView(frame: CGRect(x:1,y:1,width:1,height:1))
        let table = UITableView(frame: view.frame, style: .grouped)
        view.tableView = table
        provider = makeProvider() as! TWLinesAndStationsProviderFake
        view.model = TWInputStationViewModelFake(provider:provider)
        return view
    }

}
