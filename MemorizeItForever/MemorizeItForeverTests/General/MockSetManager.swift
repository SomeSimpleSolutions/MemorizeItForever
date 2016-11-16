//
//  MockSetManager.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 11/13/16.
//  Copyright © 2016 SomeSimpleSolutions. All rights reserved.
//

import MemorizeItForeverCore

class MockSetManager: SetManagerProtocol {
    func delete(_ setModel: SetModel) -> Bool {
        return false
    }
    
    func get() -> [SetModel] {
        return []
    }
    
    func createDefaultSet() {
        
    }
    
    func setUserDefaultSet() {
        
    }
    
    func save(_ setName: String) {
        
    }
    
    func edit(_ setModel: SetModel, setName: String) {
        
    }
}