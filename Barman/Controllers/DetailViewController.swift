//
//  DetailViewController.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var drink: Drink?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let drink = drink {
            print(drink)
        }
    }
}
