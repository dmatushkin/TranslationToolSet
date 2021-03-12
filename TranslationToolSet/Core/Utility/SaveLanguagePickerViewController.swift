//
//  SaveLanguagePickerViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/12/21.
//

import UIKit

protocol SaveLanguagePickerDelegate: class {
    
    func languageSaved(language: TranslationLanguage)
}

class SaveLanguagePickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    
    private let language: TranslationLanguage
    private let tempUrl: URL
    weak var languageDelegate: SaveLanguagePickerDelegate?
    
    init(language: TranslationLanguage) {
        self.language = language
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(language.targetLanguage + ".xliff")
        do {
            try language.serialize().write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        self.tempUrl = url
        super.init(url: url, in: .moveToService)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, let delegate = languageDelegate else { return }
        let result = TranslationLanguage(documentURL: url, sourceLanguage: self.language.sourceLanguage, targetLanguage: self.language.targetLanguage, translationFiles: self.language.translationFiles)
        delegate.languageSaved(language: result)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        do {
            try FileManager.default.removeItem(at: self.tempUrl)
        } catch {
            print(error.localizedDescription)
        }        
    }
}
