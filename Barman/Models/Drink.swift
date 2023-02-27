//
//  Drink.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import Foundation

struct Drink: Decodable {
    let name: String
    let img: String
    let ingredients: String
    let directions: String
}

typealias Drinks = [Drink]
