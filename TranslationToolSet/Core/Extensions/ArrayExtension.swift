//
//  ArrayExtension.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/11/21.
//

import Foundation

extension Array where Element: Comparable {
    
    mutating func appendMissing(from: Array<Element>) {
        for item in from {
            if !self.contains(item) {
                self.append(item)
            }
        }
    }
}
