//
//  MockWordManager.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 11/16/16.
//  Copyright © 2016 SomeSimpleSolutions. All rights reserved.
//

import MemorizeItForeverCore

class MockWordManager: WordManagerProtocol {
    func saveWord(_ phrase: String, meaninig: String, setId: UUID) {
        
    }
    
    func editWord(_ wordModel: WordModel, phrase: String, meaninig: String) {
        
    }
    
    func deleteWord(_ wordModel: WordModel) {
        
    }
}
