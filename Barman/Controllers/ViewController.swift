//
//  ViewController.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var drinks = [Drink]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let drinks = DrinkDataManager.loadDrinks() {
            self.drinks = drinks
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.drinkID) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = drinks[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.detail {
            let detailViewControler = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let drink = drinks[indexPath.row]
            detailViewControler.drink = drink
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

