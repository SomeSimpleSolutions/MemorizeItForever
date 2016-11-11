//
//  WordDataAccessProtocol.swift
//  MemorizeItForeverCore
//
//  Created by Hadi Zamani on 11/10/16.
//  Copyright © 2016 SomeSimpleSolutions. All rights reserved.
//

protocol WordDataAccessProtocol {
    func save(_ wordModel: WordModel) throws
    func edit(_ wordModel: WordModel) throws
    func delete(_ wordModel: WordModel) throws
    func fetchWithNotStartedStatus(fetchLimit: Int) throws -> [WordModel]
    func fetchLast(_ wordStatus: WordStatus) throws -> WordModel? 
}
