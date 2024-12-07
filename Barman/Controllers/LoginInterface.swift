//
//  LoginInterface.swift
//  Barman
//
//  Created by Ángel González on 07/12/24.
//

import Foundation
import UIKit
import AuthenticationServices

class LoginInterface: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    let actInd = UIActivityIndicatorView(style: .large)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reutilizar custom login para que el usuario acceda por mi backend
        let loginVC = CustomLoginViewController()
        // agregar la lógica de ejecución del controller:
        self.addChild(loginVC)
        loginVC.view.frame = CGRect(x:0, y:45, width:self.view.bounds.width, height:self.view.bounds.width)
        // agregamos la vista de customlogin como subvista
        self.view.addSubview(loginVC.view)
        // agregar boton para login con appleID
        let appleIDBtn = ASAuthorizationAppleIDButton()
        self.view.addSubview(appleIDBtn)
        appleIDBtn.center = self.view.center
        appleIDBtn.frame.origin.y = loginVC.view.frame.maxY + 10
        appleIDBtn.addTarget(self, action:#selector(appleBtnTouch), for:.touchUpInside)
    }
    
    @objc func appleBtnTouch () {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests:[request])
        authController.presentationContextProvider = self
        authController.delegate = self
        authController.performRequests()
    }
}
