//
//  CustomLoginViewController.swift
//  Loginzes
//
//  Created by Angel Gonzalez Torres on 22/11/23.
//

import UIKit

class CustomLoginViewController: UIViewController, UITextFieldDelegate {

    let label:UILabel = UILabel()
    let accountField:UITextField = UITextField()
    let passwordField:UITextField = UITextField()
    let loginButton:UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Ingresa los siguientes datos:"
        label.font = UIFont(name: "SegoeUI-Semibold", size: 16)
        label.textAlignment = .center
        self.view.addSubview(label);
        accountField.placeholder = "Correo registrado:"
        accountField.setLeftPaddingPoints(10)
        accountField.customize(false)
        self.view.addSubview(accountField)
        accountField.keyboardType = .emailAddress
        accountField.autocapitalizationType = .none
        accountField.autocorrectionType = .no
        accountField.returnKeyType = .next
        accountField.delegate = self
        
        passwordField.placeholder = "Contraseña:"
        passwordField.setLeftPaddingPoints(10)
        passwordField.customize(false)
        passwordField.isSecureTextEntry = true
        self.view.addSubview(passwordField)
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .next
        passwordField.delegate = self
    
        loginButton.backgroundColor =  Utils.UIColorFromRGB(rgbValue: colorPrimaryDark)
        loginButton.setTitle("Acceder", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rect = self.view.bounds
        label.frame = CGRect(x:10, y:60, width:rect.width - 20, height:35)
        accountField.frame = CGRect(x:20, y:label.frame.maxY + 20, width:rect.width - 40, height:35)
        passwordField.frame = CGRect(x:20, y:accountField.frame.maxY + 25, width:rect.width - 40, height:35)
        loginButton.frame = CGRect(x: 40,y:passwordField.frame.maxY+150,width:rect.width - 80,height: 45)
    }
    
    @objc func loginAction() {
        self.view.endEditing(true)
        var message = ""
        guard let account = self.accountField.text,
              let pass = self.passwordField.text
        else {
            return
        }
        if account.isEmpty {
            message = "Por favor ingrese su correo"
        }
        else if pass.isEmpty {
            message = "Por favor ingrese su password"
        }
        
        if message.isEmpty {
            Services().loginService(account, pass)
            if parent != nil {
                //let localParent = parent as! LoginInterface
                //localParent.customLogin(mail:account, password:pass)
            }
        }
        else {
            Utils.showMessage(message)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountField {
            passwordField.becomeFirstResponder()
            return false
        }
        if textField == passwordField {
            passwordField.becomeFirstResponder()
            return false
        }
        return true
    }

}

