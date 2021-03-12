//
//  UIKeyCommandExtension.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/12/21.
//

import UIKit

extension UIKeyCommand {
    
    func disabled() -> UIKeyCommand {
        self.attributes = .disabled
        return self
    }
}
