//
//  DetailViewController.swift
//  Barman
//
//  Created by C4rl0s on 26/02/23.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var directionsTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var stackViewContainerBottomConstraint: NSLayoutConstraint!
    
    var drink: Drink?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let drink = drink {
            let shareBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector(share))
            self.navigationItem.rightBarButtonItem = shareBarButtonItem
            self.title = drink.name
            self.nameTextField.text = drink.name
            self.nameTextField.isEnabled = false
            self.ingredientsTextField.text = drink.ingredients
            self.ingredientsTextField.isEnabled = false
            self.directionsTextField.text = drink.directions
            self.directionsTextField.isEnabled = false
            self.addPhotoButton.isHidden = true
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.addPhotoButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            initializeTextFields()
            updateSaveBarButtonItemState()
            registerForKeyNotification()
            self.nameTextField.delegate = self
            self.ingredientsTextField.delegate = self
            self.directionsTextField.delegate = self
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
                self.imageView.image = UIImage(named: "empty_drink.png")
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
    
    @objc func share() {
        
    }
    
    @objc func save() {
        
    }
    
    func updateSaveBarButtonItemState() {
        let name = nameTextField.text ?? ""
        let ingredients = ingredientsTextField.text ?? ""
        let directions = directionsTextField.text ?? ""
        saveBarButtonItem.isEnabled = !name.isEmpty && !ingredients.isEmpty && !directions.isEmpty
    }
    
    func initializeTextFields() {
        nameTextField.text = ""
        ingredientsTextField.text = ""
        directionsTextField.text = ""
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if nameTextField.isEditing || ingredientsTextField.isEditing || directionsTextField.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.stackViewContainerBottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.stackViewContainerBottomConstraint, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        } else {
            viewBottomConstraint.constant = 20
        }
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func registerForKeyNotification() {
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.keyboardWillShow),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil)

                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.keyboardWillHide),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil)
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveBarButtonItemState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        let name = nameTextField.text!
        let ingredients = ingredientsTextField.text!
        let directions = directionsTextField.text!
        
        drink = Drink(name: name, img: "", ingredients: ingredients, directions: directions)
    }
}
