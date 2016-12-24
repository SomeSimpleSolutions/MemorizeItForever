//
//  BaseManagedObjectContext.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 4/30/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import UIKit
import CoreData
import BaseLocalDataAccess

final class BaseManagedObjectContext: ManagedObjectContextProtocol {
    
    public init(){
    }

    public func get() -> NSManagedObjectContext{
        return ContextHelper.shared.getContext()
    }
}
