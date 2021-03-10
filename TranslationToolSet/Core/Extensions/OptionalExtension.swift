//
//  OptionalExtension.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/10/21.
//

import Foundation
import CommonError

extension Optional {
    
    func value(errorName: String) throws -> Wrapped {
        if let value = self {
            return value
        }
        throw CommonError(description: errorName)
    }
}
