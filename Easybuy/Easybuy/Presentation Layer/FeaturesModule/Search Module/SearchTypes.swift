//
//  SearchTypes.swift
//  Easybuy
//
//  Created by Yoav on 13/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

enum SearchType: String {

    case carbonatedDrinks = "Газировка"
    case chocolate = "Сладкое"
    case fruits = "Фрукты"
    case milk = "Молочное"
    case vegetables = "Овощи"
    case snacks = "Чипсы, снеки"

    var name: String {
        return self.rawValue
    }
}
