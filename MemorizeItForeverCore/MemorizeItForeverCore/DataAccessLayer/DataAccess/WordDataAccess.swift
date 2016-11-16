//
//  WordDataAccess.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 4/30/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import Foundation
import BaseLocalDataAccess

class WordDataAccess: BaseDataAccess<WordEntity>, WordDataAccessProtocol {
    
    var setDataAccess: GenericDataAccess<SetEntity>!
    
    init(genericDataAccess: GenericDataAccess<WordEntity>, setDataAccess: GenericDataAccess<SetEntity>) {
        super.init(genericDataAccess: genericDataAccess)
        self.setDataAccess = setDataAccess
    }
    
    func save(_ wordModel: WordModel) throws{
        guard let setId = wordModel.setId else{
            throw EntityCRUDError.failSaveEntity(genericDataAccess.getEntityName())
        }
        do{
            let wordEntity = try genericDataAccess.createNewInstance()
            wordEntity.id = genericDataAccess.generateId()
            wordEntity.meaning = wordModel.meaning
            wordEntity.order = try setOrder()
            wordEntity.phrase = wordModel.phrase
            wordEntity.set =  fetchSetEntity(setId)
            try genericDataAccess.saveEntity(wordEntity)
        }
        catch EntityCRUDError.failNewEntity(let entityName){
            throw EntityCRUDError.failNewEntity(entityName)
        }
        catch let error as NSError{
            throw EntityCRUDError.failSaveEntity(error.localizedDescription)
        }
    }
    
    func fetchAll(fetchLimit: Int? = nil) throws -> [WordModel] {
        do{
            let sort = SortObject(fieldName: WordEntity.Fields.Order.rawValue,direction: SortDirectionEnum.ascending )
            return try genericDataAccess.fetchModels(predicate: nil, sort: sort, fetchLimit: fetchLimit)
        }
        catch let error as NSError{
            throw  DataAccessError.failFetchData(error.localizedDescription)
        }
    }
    
    func fetchWithNotStartedStatus(fetchLimit: Int) throws -> [WordModel] {
        do{
            let sort = SortObject(fieldName: WordEntity.Fields.Order.rawValue,direction: SortDirectionEnum.ascending )
            let predicaet = PredicateObject(fieldName: WordEntity.Fields.Status.rawValue, operatorName: OperatorEnum.equal, value: Int(WordStatus.notStarted.rawValue))
            return try genericDataAccess.fetchModels(predicate: predicaet, sort: sort, fetchLimit: fetchLimit)
        }
        catch let error as NSError{
            throw  DataAccessError.failFetchData(error.localizedDescription)
        }
    }
    
    func fetchLast(_ wordStatus: WordStatus) throws -> WordModel? {
        do{
            let sort = SortObject(fieldName: WordEntity.Fields.Order.rawValue, direction: SortDirectionEnum.descending)
            let predicaet = PredicateObject(fieldName: WordEntity.Fields.Status.rawValue, operatorName: OperatorEnum.equal, value: Int(wordStatus.rawValue))
            let words: [WordModel] = try genericDataAccess.fetchModels(predicate: predicaet, sort: sort, fetchLimit: 1)
            if words.count == 1{
                return words[0]
            }
            return nil
        }
        catch let error as NSError{
            throw  DataAccessError.failFetchData(error.localizedDescription)
        }
    }
    
    func edit(_ wordModel: WordModel) throws{
        do{
            guard let id = wordModel.wordId else{
                throw EntityCRUDError.failEditEntity(genericDataAccess.getEntityName())
            }
            
            if let wordEntity = try genericDataAccess.fetchEntity(withId: id){
                wordEntity.meaning = wordModel.meaning
                wordEntity.phrase = wordModel.phrase
                if let status = wordModel.status{
                    wordEntity.status = status
                }
                try genericDataAccess.saveEntity(wordEntity)
            }
            else{
                throw DataAccessError.failFetchData("There is no Word entity with id: \(id)")
            }
        }
        catch let error as NSError{
            throw DataAccessError.failEditData(error.localizedDescription)
        }
    }
    
    func delete(_ wordModel: WordModel) throws{
        do{
            guard let id = wordModel.wordId else{
                throw EntityCRUDError.failDeleteEntity(genericDataAccess.getEntityName())
            }
            
            if let wordEntity = try genericDataAccess.fetchEntity(withId: id){
                try genericDataAccess.deleteEntity(wordEntity)
            }
            else{
                throw DataAccessError.failFetchData("There is no Word entity with id: \(id)")
            }
        }
        catch let error as NSError{
            throw DataAccessError.failDeleteData(error.localizedDescription)
        }
    }
    
    private func fetchSetEntity(_ setId: UUID) -> SetEntity?{
        guard let setDataAccess = setDataAccess else {
            fatalError("setDataAccess is not initialized")
        }
        do{
            return try setDataAccess.fetchEntity(withId: setId)
        }
        catch{
            return nil
        }
    }
    
    private func setOrder() throws -> Int32{
        do{
            let sort = SortObject(fieldName: WordEntity.Fields.Order.rawValue, direction: SortDirectionEnum.descending)
            let words = try genericDataAccess.fetchEntities(predicate: nil, sort: sort , fetchLimit: 1)
            if words.count > 0{
                let order = words[0].order
                return order + 1
            }
            return 1
        }
        catch let error as NSError{
            throw DataAccessError.failSaveData(error.localizedDescription)
        }
    }
    
}
