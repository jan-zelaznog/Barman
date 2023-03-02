//
//  DetailViewController.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var drink: Drink?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let drink = drink {
            self.title = drink.name
            self.ingredientsTextField.text = drink.ingredients
            self.directionsLabel.text = drink.directions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var imgUrl = URL(string: "")
        if let documentsURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first, let drink = drink {
            imgUrl = documentsURL.appendingPathComponent(drink.img)
        }
        
        if let imgUrl = imgUrl, FileManager.default.fileExists(atPath:imgUrl.path) {
            print("File is available")
            self.imageView.image = UIImage(contentsOfFile: imgUrl.path)
        }
        else {
            if NetworkReachability.shared.isConnected {
                guard var url = URL(string: Sites.baseURL), let stringImg = drink?.img else { return }
                url.appendPathComponent(stringImg)
                let configuration = URLSessionConfiguration.ephemeral
                let session = URLSession(configuration: configuration)
                let request = URLRequest (url: url)
                let task = session.dataTask(with: request) { [self] bytes, response, error in
                    if error == nil {
                        guard let data = bytes, let uiImage = UIImage(data: data) else { return }
                        DispatchQueue.main.sync {
                            self.imageView.image = uiImage
                        }
                        saveImageDocumentDirectory(string: stringImg, image: uiImage)
                    }
                }
                task.resume()
            } else {
                showNoWifiAlert()
            }
        }
    }
    
    func saveImageDocumentDirectory(string: String, image: UIImage) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documents = documents else { return }
        let url = documents.appendingPathComponent(string)
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
            }
        }
    }
    
    func showNoWifiAlert() {
        let alertController = UIAlertController (title: "Connection error", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
