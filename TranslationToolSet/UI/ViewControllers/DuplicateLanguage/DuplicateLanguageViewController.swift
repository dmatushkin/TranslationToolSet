//
//  DuplicateLanguageViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/11/21.
//

import UIKit

class DuplicateLanguageViewController: UIViewController {
    
    @IBOutlet private var newLanguageField: UITextField!
    weak var mainModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    @IBAction private func duplicateAction() {
        guard let code = self.newLanguageField.text, !code.isEmpty else { return }
        self.mainModel?.duplicateLanguage(with: code)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
