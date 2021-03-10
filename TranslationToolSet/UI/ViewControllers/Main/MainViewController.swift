//
//  MainViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import UIKit

class MainViewController: UIViewController, UIDocumentPickerDelegate {
    
    static var instance: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewController.instance = self
    }
    
    func openXliffFile() {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.mdd.xliff"], in: .import)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

