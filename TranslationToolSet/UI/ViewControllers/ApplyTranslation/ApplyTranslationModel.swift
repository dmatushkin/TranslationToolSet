//
//  ApplyTranslationModel.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

class ApplyTranslationModel: RowHeightDelegate, ApplyTransitionHeaderDelegate, LanguageSelectionDelegate {
    
    weak var controller: ApplyTranslationViewController!
    fileprivate var data: [[String]] = []
    fileprivate var languages: [Int: String] = [:]
    fileprivate var translationLanguages: [TranslationLanguage] = []
    
    class ApplyTranslationCollectionDataSource: NSObject, UICollectionViewDataSource {
        
        fileprivate weak var model: ApplyTranslationModel!
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return self.model.data.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard section >= 0 && section < self.model.data.count else { return 0 }
            return self.model.data[section].count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyTranslationItemCollectionViewCell", for: indexPath) as? ApplyTranslationItemCollectionViewCell else { fatalError() }
            let item = self.model.data[indexPath.section][indexPath.item]
            cell.setup(with: item)
            cell.contentView.backgroundColor = indexPath.item == 0 ? UIColor.opaqueSeparator : UIColor.clear
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ApplyTranslationHeaderReusableView", for: indexPath) as? ApplyTranslationHeaderReusableView else { fatalError() }
            header.setup(language: self.model.languages[indexPath.item], rowNumber: indexPath.item, delegate: self.model)
            return header
        }
    }
    
    func translationRowHeight(section: Int, cellWidth: CGFloat) -> CGFloat {
        guard section >= 0 && section < self.data.count else { return 0 }
        
        var maxHeight: CGFloat = 0
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        for item in self.data[section] {
            label.text = item
            let labelSize = label.systemLayoutSizeFitting(CGSize(width: cellWidth - 30, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            maxHeight = max(maxHeight, labelSize.height)
        }
        return max(maxHeight + 30, 50)
    }
    
    func process(tsvURL: URL?, languages: [TranslationLanguage]) {
        guard let tsvURL = tsvURL else { return }
        self.translationLanguages = languages
        do {
            let content = try String(contentsOf: tsvURL)
            self.data = content.split(separator: "\n").map({ $0.split(separator: "\t").map({ String($0) }) })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setLanguage(forRow row: Int, source: UIButton) {
        guard let controller = self.controller.storyboard?.instantiateViewController(withIdentifier: "LanguageSelectionViewController") as? LanguageSelectionViewController else { return }
        controller.languages = self.translationLanguages
        controller.row = row
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = source
        controller.delegate = self
        self.controller.present(controller, animated: true, completion: nil)
    }
    
    func languageSelected(language: TranslationLanguage, forRow: Int) {
        if let item = self.languages.first(where: {(_, value) in value == language.targetLanguage }), item.key != forRow {
            self.languages[item.key] = nil
        }
        self.languages[forRow] = language.targetLanguage
        self.controller.reloadCollection()
    }
    
    func clearLanguage(forRow row: Int, source: UIButton) {
        self.languages[row] = nil
        self.controller.reloadCollection()
    }
    
    func applyTranslation() {
        for (idx, languageCode) in self.languages {
            for row in self.data where row.count > idx {
                let key = row[0]
                let value = row[idx]
                let items = self.translationLanguages.filter({ $0.targetLanguage == languageCode }).flatMap({ $0.translationFiles }).flatMap({ $0.translationUnits }).filter({ $0.source == key })
                for item in items {
                    item.target = value
                }
            }
        }
    }
    
    let applyTranslationCollectionDataSource = ApplyTranslationCollectionDataSource()
    
    init() {
        self.applyTranslationCollectionDataSource.model = self
    }
}
