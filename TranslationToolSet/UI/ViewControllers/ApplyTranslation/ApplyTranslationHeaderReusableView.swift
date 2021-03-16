//
//  ApplyTranslationHeaderReusableView.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

protocol ApplyTransitionHeaderDelegate: class {
    func setLanguage(forRow row: Int, source: UIButton)
    func clearLanguage(forRow row: Int, source: UIButton)
}

class ApplyTranslationHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet private var languageLabel: UILabel!
    @IBOutlet private var setButton: UIButton!
    @IBOutlet private var clearButton: UIButton!
    private var rowNumber: Int = 0
    private weak var delegate: ApplyTransitionHeaderDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(language: String?, rowNumber: Int, delegate: ApplyTransitionHeaderDelegate) {
        self.languageLabel.text = language ?? "Language not set"
        self.rowNumber = rowNumber
        self.delegate = delegate
        self.clearButton.isEnabled = language != nil
        self.setButton.isHidden = rowNumber == 0
        self.clearButton.isHidden = rowNumber == 0
        self.languageLabel.isHidden = rowNumber == 0
    }
    
    @IBAction private func setAction() {
        self.delegate?.setLanguage(forRow: self.rowNumber, source: self.setButton)
    }
    
    @IBAction private func clearAction() {
        self.delegate?.clearLanguage(forRow: self.rowNumber, source: self.clearButton)
    }
}
