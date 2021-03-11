//
//  MainViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import UIKit

class MainViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet private var sectionsTable: UITableView!
    @IBOutlet private var translationCollection: UICollectionView!
    
    static var instance: MainViewController?
    private let model = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewController.instance = self
        model.controller = self
        self.translationCollection.collectionViewLayout = TranslationsGridLayout()
        self.sectionsTable.dataSource = self.model.sectionsListDataSource
        self.sectionsTable.delegate = self.model.sectionsListDataSource
        self.translationCollection.dataSource = self.model.translationsCollectionDataSource
    }
    
    func reloadSectionsTable() {
        self.sectionsTable.reloadData()
        self.translationCollection.reloadData()
        self.translationCollection.contentOffset = .zero
    }
    
    func openXliffFile() {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)        
    }
    
    func duplicateLanguage() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DuplicateLanguageViewController") as? DuplicateLanguageViewController else { return }
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = self.translationCollection
        controller.mainModel = self.model
        self.present(controller, animated: true, completion: nil)
    }
    
    func saveChanges() {
        self.model.saveChanges()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            self.model.addDocument(url: url)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

