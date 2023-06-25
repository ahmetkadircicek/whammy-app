//
//  Extensions.swift
//  Whammy
//
//  Created by Ahmet on 20.06.2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
