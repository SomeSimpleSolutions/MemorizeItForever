//
//  MemorizeItTableDataSource.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 5/25/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import UIKit

public protocol MemorizeItTableDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    func setModels(_ models: [MemorizeItModelProtocol])
    init(handleTap: TypealiasHelper.handleTapClosure?)
}
