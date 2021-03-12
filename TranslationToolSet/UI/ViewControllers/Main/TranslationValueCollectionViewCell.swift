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

class TranslationValueCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet private var textField: UITextView!
    private var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    weak var updateDelegate: TranslationValueUpdateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(value: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.textField.text = value
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateDelegate?.apply(value: self.textField.text ?? "", for: self.indexPath)
    }
}
