//
//  TranslationUnit.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import Foundation

class TranslationUnit {
    
    let unitId: String
    let source: String
    var target: String
    let note: String
    
    init(unitId: String, source: String, target: String, note: String) {
        self.unitId = unitId
        self.source = source
        self.target = target
        self.note = note
    }
}
