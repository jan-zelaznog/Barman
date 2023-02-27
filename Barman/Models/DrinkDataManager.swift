//
//  DringDataManager.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import Foundation

class DrinkDataManager {
    
    var drinks : [Drink] = []

    func loadDrinks() {
        if let file = Bundle.main.url(forResource: "drinks", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                drinks = try JSONDecoder().decode(Drinks.self, from: data)
            } catch {
                print("Error", error)
            }
        }
    }
    
    func count() -> Int {
        drinks.count
    }
    
    func drink(at index: Int) -> Drink {
        return drinks[index]
    }
}

