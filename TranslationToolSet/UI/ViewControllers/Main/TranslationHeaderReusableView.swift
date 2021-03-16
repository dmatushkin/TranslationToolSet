//
//  TranslationHeaderReusableView.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class TranslationHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet private var sectionHeaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(title: String) {
        self.sectionHeaderLabel.text = title
    }
}
