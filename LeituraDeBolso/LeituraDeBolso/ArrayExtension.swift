//
//  ArrayExtension.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 11/09/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    func removeObject(_ object: Element) -> [Element] {
        return filter { $0 != object }
    }
}
