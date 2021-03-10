//
//  TranslationFile.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import Foundation

class TranslationFile {
    
    let filePath: String
    let toolId: String
    let toolName: String
    let toolVersion: String
    let toolBuildNumber: String
    let translationUnits: [TranslationUnit]
    
    init(filePath: String, toolId: String, toolName: String, toolVersion: String, toolBuildNumber: String, translationUnits: [TranslationUnit]) {
        self.filePath = filePath
        self.toolId = toolId
        self.toolName = toolName
        self.toolVersion = toolVersion
        self.toolBuildNumber = toolBuildNumber
        self.translationUnits = translationUnits
    }
}
