//
//  TranslationValueCollectionViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

protocol TranslationValueUpdateDelegate: class {
    
    func apply(value: String, for indexPath: IndexPath)
}

class TranslationValueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var textField: UITextField!
    private var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    weak var updateDelegate: TranslationValueUpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.addTarget(self, action: #selector(didUpdate), for: .editingChanged)
    }
    
    func setup(value: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.textField.text = value
    }
    
    @objc private func didUpdate() {
        self.updateDelegate?.apply(value: self.textField.text ?? "", for: self.indexPath)
    }
}
