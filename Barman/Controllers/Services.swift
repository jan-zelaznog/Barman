//
//  Services.swift
//  Barman
//
//  Created by Ángel González on 06/12/24.
//

import Foundation

class Services {
    
    func loginService (_ username:String, _ password:String) {
        if let laURL = URL(string: baseUrl + "/WS/login.php") {
            let sesion = URLSession(configuration: .default)
            var elRequest = URLRequest(url: laURL)
            elRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            elRequest.httpMethod = "POST"
            let paramString = "username=\(username)&password=\(password)"
            elRequest.httpBody = paramString.data(using: .utf8)
            let elTask = sesion.dataTask(with: elRequest) { (datos, response, error) in
                // TODO: implementar el manejo de error y la conversion de los datos recibidos
                print (response)
                print ("llego")
            }
            elTask.resume()
        }
    }
}
