//
//  TranslationKeyCollectionViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class TranslationKeyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var keyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(with key: String) {
        self.keyLabel.text = key
    }
}
