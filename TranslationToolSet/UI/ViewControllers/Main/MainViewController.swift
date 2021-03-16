//
//  MainViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private var sectionsTable: UITableView!
    @IBOutlet private var translationCollection: UICollectionView!
    
    static var instance: MainViewController?
    private let model = MainViewModel()
    private let layout = TranslationsGridLayout()
    private var loadIndicator: LoadIndicatorViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewController.instance = self
        self.model.controller = self
        self.layout.rowHeightDelegate = self.model
        self.translationCollection.collectionViewLayout = self.layout
        self.sectionsTable.dataSource = self.model.sectionsListDataSource
        self.sectionsTable.delegate = self.model.sectionsListDataSource
        self.translationCollection.dataSource = self.model.translationsCollectionDataSource
        self.loadIndicator = self.storyboard!.instantiateViewController(withIdentifier: "LoadIndicatorViewController") as! LoadIndicatorViewController
    }
    
    func reloadSectionsTable() {
        self.sectionsTable.reloadData()
        self.translationCollection.reloadData()
        self.translationCollection.contentOffset = .zero
    }
    
    func openXliffFile() {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = self.model.addLanguagePickerDelegate
        self.present(picker, animated: true, completion: nil)        
    }
    
    func openXcodeExportedFolder() {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeFolder)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = self.model.addExportedFolderPickerDelegate
        self.present(picker, animated: true, completion: nil)
    }
    
    func showLoadIndicator() {
        self.present(self.loadIndicator, animated: false, completion: nil)
    }
    
    func hideLoadIndicator() {
        self.loadIndicator.dismiss(animated: false, completion: nil)
    }
    
    func duplicateLanguage() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DuplicateLanguageViewController") as? DuplicateLanguageViewController else { return }
        controller.delegate = self.model
        self.present(controller, animated: true, completion: nil)
    }
    
    func saveDuplicateLanguage(language: TranslationLanguage) {
        let picker = SaveLanguagePickerViewController(language: language)
        picker.allowsMultipleSelection = false
        picker.languageDelegate = self.model.duplicateLanguagePickerDelegate
        self.present(picker, animated: true, completion: nil)
    }
    
    func saveChanges() {
        self.model.saveChanges()
    }
    
    func exportTranslationKeys() {
        let keys = self.model.translationnKeys()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("keys.txt")
        do {
            try keys.write(to: url, atomically: true, encoding: .utf8)
            let picker = UIDocumentPickerViewController(url: url, in: .moveToService)
            self.present(picker, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func applyTsv() {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = self.model.applyTranslationPickerDelegate
        self.present(picker, animated: true, completion: nil) 
    }
}

