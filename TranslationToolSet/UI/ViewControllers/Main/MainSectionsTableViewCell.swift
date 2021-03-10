//
//  MainSectionsTableViewCell.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class MainSectionsTableViewCell: UITableViewCell {
    
    @IBOutlet private var sectionTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with title: String, isSelected: Bool) {
        self.sectionTitleLabel.text = title
        self.backgroundColor = isSelected ? UIColor.green.withAlphaComponent(0.2) : UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
