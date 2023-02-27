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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.drinkID) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = drinkDataManager.drink(at: indexPath.row).name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.detail {
            let detailViewControler = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let drink = drinkDataManager.drinks[indexPath.row]
            detailViewControler.drink = drink
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueID.detail, sender: self)
    }
}

