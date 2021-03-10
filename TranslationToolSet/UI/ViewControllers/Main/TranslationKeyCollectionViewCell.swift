//
//  TranslationKeyCollectionViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class TranslationKeyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var keyLabel: UILabel!
    
    func setup(with key: String) {
        self.keyLabel.text = key
    }
}
