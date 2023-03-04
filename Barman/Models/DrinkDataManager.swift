//
//  DringDataManager.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import Foundation

struct DrinkDataManager {

    static func loadDrinks() -> [Drink]? {
        if let file = Bundle.main.url(forResource: File.main.name, withExtension: File.main.extension) {
            guard let data = try? Data(contentsOf: file) else { return nil }
            return try? JSONDecoder().decode([Drink].self, from: data)
        } else {
            return nil
        }
    }
}

