//
//  Guitar.swift
//  Whammy
//
//  Created by Ahmet on 20.06.2023.
//

import Foundation

struct TrendingGuitarsResponse: Codable {
    let trending: [Guitar]
}

struct Guitar: Codable {
    let id: Int
    let posterPath: String?
    let model: String
    let onSale: Bool
}




