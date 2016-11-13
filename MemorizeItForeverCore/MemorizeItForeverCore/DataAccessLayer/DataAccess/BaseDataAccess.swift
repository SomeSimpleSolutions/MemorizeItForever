//
//  BaseDataAccess.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 4/30/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import BaseLocalDataAccess
import CoreData

public class BaseDataAccess<T>: DataAccessProtocol where T: EntityProtocol, T: AnyObject, T: NSFetchRequestResult {
    public var dataAccess: GenericDataAccess<T>
    var context: ManagedObjectContextProtocol
    
    public init(context: ManagedObjectContextProtocol){
        do{
            self.context = context
            dataAccess = try GenericDataAccess<T>(context: context)
        }
        catch{
            fatalError(error.localizedDescription)
        }
    }
}
