//
//  TranslationsGridLayout.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import UIKit

class TranslationsGridLayout: UICollectionViewLayout {

    private let itemWidth: CGFloat = 200
    private let itemHeight: CGFloat = 50
    private let headerHeight: CGFloat = 30
    
    override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    override func prepare() {
        super.prepare()
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
            for section in 0..<collection.numberOfSections {
                let frame = CGRect(x: CGFloat(item) * itemWidth, y: CGFloat(section) * itemHeight + headerHeight, width: itemWidth, height: itemHeight)
                if frame.intersects(rect) {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                    attributes.frame = frame
                    attributes.zIndex = 0
                    result.append(attributes)
                }
            }
        }
        return result
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collection = self.collectionView, collection.numberOfSections > 0 else { return .zero }
        return CGSize(width: CGFloat(collection.numberOfItems(inSection: 0)) * itemWidth, height: CGFloat(collection.numberOfSections) * itemHeight + headerHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
