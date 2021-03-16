//
//  LanguageSelectionTableViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

class LanguageSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet private var languageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(language: TranslationLanguage) {
        self.languageLabel.text = language.targetLanguage
    }
}
