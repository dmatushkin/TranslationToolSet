//
//  ApplyTranslationItemCollectionViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

class ApplyTranslationItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var translationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(with item: String) {
        self.translationLabel.text = item
    }
}
