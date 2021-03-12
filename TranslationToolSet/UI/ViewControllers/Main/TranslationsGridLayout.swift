//
//  TranslationsGridLayout.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class TranslationsGridLayout: UICollectionViewLayout {

    private let itemWidth: CGFloat = 250
    private let itemHeight: CGFloat = 50
    private let headerHeight: CGFloat = 30
    weak var model: MainViewModel!
    private var rowHeights:[CGFloat] = []
    private var calculatedContentSize: CGSize = .zero
    
    override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    override func prepare() {
        super.prepare()
        self.rowHeights = []
        guard let collection = self.collectionView, collection.numberOfSections > 0 else { return }
        for section in 0..<collection.numberOfSections {
            let rowHeight = self.model.translationRowHeight(section: section, cellWidth: itemWidth)
            self.rowHeights.append(rowHeight)
        }
        self.calculatedContentSize = CGSize(width: CGFloat(collection.numberOfItems(inSection: 0)) * itemWidth, height: self.rowHeights.reduce(0, { $0 + $1 }) + headerHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: CGFloat(indexPath.item) * itemWidth, y: CGFloat(indexPath.section) * itemHeight + headerHeight, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collection = self.collectionView, collection.numberOfSections > 0 else { return nil }
        var result: [UICollectionViewLayoutAttributes] = []
        for item in 0..<collection.numberOfItems(inSection: 0) {
            let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: item, section: 0))
            header.frame = CGRect(x: CGFloat(item) * itemWidth, y: collection.contentOffset.y, width: itemWidth, height: headerHeight)
            header.zIndex = 1
            result.append(header)
        }
        var offset: CGFloat = headerHeight
        for section in 0..<collection.numberOfSections {
            let rowHeight = self.rowHeights[section]
            for item in 0..<collection.numberOfItems(inSection: 0) {
                let frame = CGRect(x: CGFloat(item) * itemWidth, y: offset, width: itemWidth, height: rowHeight)
                if frame.intersects(rect) {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                    attributes.frame = frame
                    attributes.zIndex = 0
                    result.append(attributes)
                }                
            }
            offset += rowHeight
        }
        return result
    }
    
    override var collectionViewContentSize: CGSize {
        return self.calculatedContentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
