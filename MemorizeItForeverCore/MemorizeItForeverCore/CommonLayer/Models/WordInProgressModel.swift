//
//  WordInProgress.swift
//  MemorizeItForever
//
//  Created by Hadi Zamani on 3/21/16.
//  Copyright © 2016 SomeSimpleSolution. All rights reserved.
//

import UIKit

public struct WordInProgressModel: MemorizeItModelProtocol {
    var word: WordModel?
    var date: Date?
    var column: Int16?
    var wordInProgressId: UUID?
}

public func ==(lhs: WordInProgressModel, rhs: WordInProgressModel) -> Bool {
    return lhs.wordInProgressId == rhs.wordInProgressId
}
