//
//  Recommendations.swift
//  Easybuy
//
//  Created by Yoav on 11/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

struct Recommendations: Codable {
    let large, medium, small: [String]?
    let error: String?
}

struct SearchItems: Codable {
    let searchResult: [String]?
}
