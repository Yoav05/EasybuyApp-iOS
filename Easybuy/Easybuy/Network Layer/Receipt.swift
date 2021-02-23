//
//  Receipt.swift
//  Easybuy
//
//  Created by Yoav on 06/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

struct Receipt {
    let products: [String]
    let timeStamp: String
    
    func joinProducts() -> String {
        var results = [String]()
        for (index, value) in products.enumerated() {
            results.append("\(index + 1). " + value.split(whereSeparator: { !$0.isLetter }).joined(separator: " "))
        }
        return results.joined(separator: "\n")
    }
}
