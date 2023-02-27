//
//  ViewController.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let drinkDataManager = DrinkDataManager()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        drinkDataManager.loadDrinks()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkDataManager.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellDrinkID") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = drinkDataManager.drink(at: indexPath.row).name
        return cell
    }
}

