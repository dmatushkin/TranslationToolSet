//
//  ApplyTranslationViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

protocol TranslationsListReloadDelegate: class {
    func reloadData()
}

class ApplyTranslationViewController: UIViewController {
    
    @IBOutlet private var itemsCollection: UICollectionView!
    let model = ApplyTranslationModel()
    private let layout = TranslationsGridLayout()
    weak var reloadDelegate: TranslationsListReloadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 1000, height: 600)
        self.model.controller = self
        self.layout.rowHeightDelegate = self.model
        self.itemsCollection.dataSource = self.model.applyTranslationCollectionDataSource
        self.itemsCollection.collectionViewLayout = self.layout
    }
    
    func reloadCollection() {
        self.itemsCollection.reloadData()
    }
    
    @IBAction private func applyAction() {
        self.model.applyTranslation()
        self.reloadDelegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func cancelAction() {
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
