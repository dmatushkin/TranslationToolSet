//
//  TranslationLanguage.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import Foundation
import SwiftSoup
import CommonError

class TranslationLanguage {
    
    let documentURL: URL
    let sourceLanguage: String
    let targetLanguage: String
    var translationFiles: [TranslationFile]
    
    init(documentURL: URL, sourceLanguage: String, targetLanguage: String, translationFiles: [TranslationFile]) {
        self.documentURL = documentURL
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.translationFiles = translationFiles
    }
    
    init(documentURL: URL, fileContent: String) throws {
        self.documentURL = documentURL
        let xml = try SwiftSoup.parse(fileContent, "", Parser.xmlParser())
        let files = try xml.getElementsByTag("file")
        
        self.targetLanguage = try files.first().value(errorName: "files list is empty").attr("target-language")
        self.sourceLanguage = try files.first().value(errorName: "files list is empty").attr("source-language")
        self.translationFiles = try files.map({file -> TranslationFile in
            let filePath = try file.attr("original")
            let headerTool = try file.getElementsByTag("header").first().value(errorName: "no header").getElementsByTag("tool").first().value(errorName: "no tool")
            let toolId = try headerTool.attr("tool-id")
            let toolName = try headerTool.attr("tool-name")
            let toolVersion = try headerTool.attr("tool-version")
            let toolBuildNum = try headerTool.attr("build-num")
            
            let transUnits = try file.getElementsByTag("trans-unit").map({unit -> TranslationUnit in
                let unitId = try unit.attr("id")
                let source = try unit.getElementsByTag("source").first().value(errorName: "no unit source").text()
                let target = try unit.getElementsByTag("target").first()?.text() ?? ""
                let note = try unit.getElementsByTag("note").first()?.text() ?? ""
                return TranslationUnit(unitId: unitId, source: source, target: target, note: note)
            })
            return TranslationFile(filePath: filePath, toolId: toolId, toolName: toolName, toolVersion: toolVersion, toolBuildNumber: toolBuildNum, translationUnits: transUnits)
        })
    }
    
    func serialize() throws -> String {
        let src =
"""
<?xml version="1.0" encoding="UTF-8"?>
<xliff xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.2" xsi:schemaLocation="urn:oasis:names:tc:xliff:document:1.2 http://docs.oasis-open.org/xliff/v1.2/os/xliff-core-1.2-strict.xsd">
</xliff>
"""
        let xml = try SwiftSoup.parse(src, "", Parser.xmlParser())
        let root = try xml.getElementsByTag("xliff").first().value(errorName: "no xliff")
        for file in translationFiles {
            let fileElement = try root.appendElement("file")
            try fileElement.attr("original", file.filePath)
            try fileElement.attr("source-language", sourceLanguage)
            try fileElement.attr("target-language", targetLanguage)
            try fileElement.attr("datatype", "plaintexts")
            try fileElement.appendElement("header").append("<tool tool-id=\"\(file.toolId)\" tool-name=\"\(file.toolName)\" tool-version=\"\(file.toolVersion)\" build-num=\"\(file.toolBuildNumber)\"/>")
            let body = try fileElement.appendElement("body")
            for unit in file.translationUnits {
                let unitElement = try body.appendElement("trans-unit")
                try unitElement.attr("id", unit.unitId)
                try unitElement.attr("xml:space", "preserve")
                let source = try unitElement.appendElement("source")
                try source.text(unit.source)
                let target = try unitElement.appendElement("target")
                try target.text(unit.target)
                let note = try unitElement.appendElement("note")
                try note.text(unit.note)
            }
        }
        return try xml.outerHtml()
    }
}
