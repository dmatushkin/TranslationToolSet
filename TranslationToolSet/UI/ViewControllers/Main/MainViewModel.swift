//
//  MainViewModel.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import Foundation
import UIKit

class MainViewModel: TranslationValueUpdateDelegate, DuplicateLanguageDelegate, RowHeightDelegate, TranslationsListReloadDelegate {
    
    private static let backgroundQueue = DispatchQueue(label: "data_load_queue", qos: .utility)
    
    class SectionsListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        fileprivate weak var model: MainViewModel!
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.model.sections.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainSectionsTableViewCell", for: indexPath) as? MainSectionsTableViewCell else { fatalError() }
            let title = self.model.sections[indexPath.row].split(separator: "/").last ?? ""
            cell.setup(with: String(title), isSelected: indexPath.row == model.selectedSection)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.model.selectedSection = indexPath.row
            self.model.sectionSelected()
        }
    }
    
    class TranslationsDataSource: NSObject, UICollectionViewDataSource {
        
        fileprivate weak var model: MainViewModel!
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return model.keys.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return model.languages.count + 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TranslationKeyCollectionViewCell", for: indexPath) as? TranslationKeyCollectionViewCell else { fatalError() }
                cell.setup(with: self.model.keys[indexPath.section])
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TranslationValueCollectionViewCell", for: indexPath) as? TranslationValueCollectionViewCell else { fatalError() }
            let languageIdx = indexPath.item - 1
            let key = self.model.keys[indexPath.section]
            let currentSection = self.model.sections[self.model.selectedSection]
            let value = self.model.languages[languageIdx].translationFiles.filter({ $0.filePath == currentSection }).first?.translationUnits.filter({ $0.source == key }).first?.target
            cell.setup(value: value ?? "", indexPath: indexPath)
            cell.updateDelegate = self.model
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TranslationHeaderReusableView", for: indexPath) as? TranslationHeaderReusableView else { fatalError() }
            if indexPath.item == 0 {
                header.setup(title: self.model.languages[0].sourceLanguage)
            } else {
                header.setup(title: self.model.languages[indexPath.item - 1].targetLanguage)
            }
            return header
        }
    }
    
    class AddLanguagePickerDelegate: NSObject, UIDocumentPickerDelegate {
        
        fileprivate weak var model: MainViewModel!
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.model.controller.showLoadIndicator()
            MainViewModel.backgroundQueue.async {[unowned self] in
                for url in urls {
                    self.model.addDocument(url: url)
                }
                DispatchQueue.main.async {[unowned self] in
                    self.model.controller.hideLoadIndicator()
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            
        }
    }
    
    class AddExportedFolderPickerDelegate: NSObject, UIDocumentPickerDelegate {
        
        fileprivate weak var model: MainViewModel!
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.model.controller.showLoadIndicator()
            MainViewModel.backgroundQueue.async {[unowned self] in
                for url in urls {
                    self.model.addFolder(url: url)
                }
                DispatchQueue.main.async {[unowned self] in
                    self.model.controller.hideLoadIndicator()
                }
            }            
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            
        }
    }
    
    class DuplicateLanguagePickerDelegate: NSObject, SaveLanguagePickerDelegate {
        
        fileprivate weak var model: MainViewModel!
        
        func languageSaved(language: TranslationLanguage) {
            self.model.languages.append(language)
        }
    }
    
    class ApplyTranslationPickerDelegate: NSObject, UIDocumentPickerDelegate {
        fileprivate weak var model: MainViewModel!
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let controller = self.model.controller.storyboard?.instantiateViewController(withIdentifier: "ApplyTranslationViewController") as? ApplyTranslationViewController else { return }
            controller.model.process(tsvURL: urls.first, languages: self.model.languages)
            controller.reloadDelegate = self.model
            self.model.controller.present(controller, animated: true, completion: nil)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            
        }
    }
    
    let sectionsListDataSource = SectionsListDataSource()
    let translationsCollectionDataSource = TranslationsDataSource()
    let addLanguagePickerDelegate = AddLanguagePickerDelegate()
    let duplicateLanguagePickerDelegate = DuplicateLanguagePickerDelegate()
    let addExportedFolderPickerDelegate = AddExportedFolderPickerDelegate()
    let applyTranslationPickerDelegate = ApplyTranslationPickerDelegate()
    weak var controller: MainViewController!
    
    private var languages: [TranslationLanguage] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.reloadLanguages()
            }
        }
    }
    
    private var sections: [String] = []
    private var selectedSection: Int = 0
    private var keys: [String] = []
    
    init() {
        self.sectionsListDataSource.model = self
        self.translationsCollectionDataSource.model = self
        self.addLanguagePickerDelegate.model = self
        self.duplicateLanguagePickerDelegate.model = self
        self.addExportedFolderPickerDelegate.model = self
        self.applyTranslationPickerDelegate.model = self
    }
    
    private func reloadLanguages() {
        var res = [String]()
        for language in languages {
            let languageFiles = language.translationFiles.map({ $0.filePath })
            res.appendMissing(from: languageFiles)
        }
        self.sections = res
        self.selectedSection = 0
        self.recalculateTranslations()
        self.needsToReloadSections()
    }
    
    func reloadData() {
        self.needsToReloadSections()
    }
    
    func translationRowHeight(section: Int, cellWidth: CGFloat) -> CGFloat {
        guard section >= 0 && section < self.keys.count else { return 0 }
        let key = self.keys[section]
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.text = key
        let labelSize = label.systemLayoutSizeFitting(CGSize(width: cellWidth - 30, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return max(labelSize.height + 30, 50)
    }
    
    func addDocument(url: URL) {
        do {
            let fileContent = try String(contentsOf: url)
            let language = try TranslationLanguage(documentURL: url, fileContent: fileContent)
            self.languages.append(language)
            DispatchQueue.main.async {
                AppDelegate.duplicateCommand.attributes = []
                AppDelegate.exportKeysCommand.attributes = []
                AppDelegate.applyTSVCommand.attributes = []
                UIMenuSystem.main.setNeedsRebuild()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addFolder(url: URL) {
        do {
            let list = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for item in list {
                var isDirectory: ObjCBool = false
                FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory)
                if isDirectory.boolValue {
                    self.addFolder(url: item)
                } else if item.absoluteString.hasSuffix(".xliff") {
                    self.addDocument(url: item)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func recalculateTranslations() {
        let currentSection = self.sections[self.selectedSection]
        var res: [String] = []
        for language in self.languages {
            if let file = language.translationFiles.filter({ $0.filePath == currentSection }).first {
                let keys = file.translationUnits.map({ $0.source })
                res.appendMissing(from: keys)
            }
        }
        self.keys = res
    }
    
    private func sectionSelected() {
        self.recalculateTranslations()
        self.needsToReloadSections()
    }
    
    private func needsToReloadSections() {
        self.controller.reloadSectionsTable()
    }
    
    func apply(value: String, for indexPath: IndexPath) {
        let languageIdx = indexPath.item - 1
        let key = self.keys[indexPath.section]
        let currentSection = self.sections[self.selectedSection]
        if let file = self.languages[languageIdx].translationFiles.filter({ $0.filePath == currentSection }).first {
            self.apply(value: value, for: key, translationFile: file)
        } else {
            let sample = self.languages[languageIdx].translationFiles[0]
            let file = TranslationFile(filePath: currentSection, toolId: sample.toolId, toolName: sample.toolName, toolVersion: sample.toolVersion, toolBuildNumber: sample.toolBuildNumber, translationUnits: [])
            self.apply(value: value, for: key, translationFile: file)
            self.languages[languageIdx].translationFiles.append(file)
        }
    }
    
    func apply(value: String, for key: String, translationFile: TranslationFile) {
        let units = translationFile.translationUnits.filter({ $0.source == key })
        if units.isEmpty {
            let unit = TranslationUnit(unitId: value, source: key, target: value, note: "")
            translationFile.translationUnits.append(unit)
        } else {
            for unit in units {
                unit.target = value
            }
        }
    }
    
    func saveChanges() {
        for language in self.languages {
            do {
                let str = try language.serialize()
                try str.write(to: language.documentURL, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func duplicateLanguage(with code: String) {
        var files: [String] = []
        for language in self.languages {
            files.appendMissing(from: language.translationFiles.map({ $0.filePath }))
        }
        let translationFiles = files.map({ file -> TranslationFile in
            var keys: [String] = []
            for language in self.languages {
                for translationFile in language.translationFiles.filter({ $0.filePath == file }) {
                    keys.appendMissing(from: translationFile.translationUnits.map({ $0.source }))
                }
            }
            let units = keys.map({ key -> TranslationUnit in
                let origUnit = self.languages.flatMap({ $0.translationFiles }).filter({ $0.filePath == file }).flatMap({ $0.translationUnits }).first(where: { $0.source == key })
                return TranslationUnit(unitId: origUnit?.unitId ?? key, source: key, target: "", note: origUnit?.note ?? "")
            })
            let toolId = self.languages.flatMap({ $0.translationFiles }).map({ $0.toolId }).first ?? ""
            let toolName = self.languages.flatMap({ $0.translationFiles }).map({ $0.toolName }).first ?? ""
            let toolVersion = self.languages.flatMap({ $0.translationFiles }).map({ $0.toolVersion }).first ?? ""
            let toolBuildNumber = self.languages.flatMap({ $0.translationFiles }).map({ $0.toolBuildNumber }).first ?? ""
            return TranslationFile(filePath: file, toolId: toolId, toolName: toolName, toolVersion: toolVersion, toolBuildNumber: toolBuildNumber, translationUnits: units)
        })
        let newLanguage = TranslationLanguage(documentURL: URL(fileURLWithPath: ""), sourceLanguage: self.languages[0].sourceLanguage, targetLanguage: code, translationFiles: translationFiles)
        self.controller.saveDuplicateLanguage(language: newLanguage)
    }
    
    func translationnKeys() -> String {
        var result: [String] = []
        for language in self.languages {
            for file in language.translationFiles {
                result.appendMissing(from: file.translationUnits.map({ $0.source }))
            }
        }
        return result.joined(separator: "\n")
    }
}
