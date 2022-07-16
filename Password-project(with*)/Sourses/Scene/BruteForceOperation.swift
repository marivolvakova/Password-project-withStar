//
//  BruteForce.swift
//  Password-project(with*)
//
//  Created by Мария Вольвакова on 16.07.2022.
//

import Foundation


class BruteforceOperation: Operation {
   static let allowedCharacters: [String] = String().printable.map { String($0) }
    

   static func bruteForce(passwordToUnlock: String) {
       var password: String = ""
       while password != passwordToUnlock && ViewController.isRunning {
           password = String.generateBruteForce(password, fromArray: allowedCharacters)
            
            DispatchQueue.main.async {
                ViewController.label.text = "Ваш пароль - \(password)"
                ViewController.activityIndicator.startAnimating()
            }
            print(password)
        }
        
        DispatchQueue.main.async {
            ViewController.textField.isSecureTextEntry = false
            ViewController.activityIndicator.stopAnimating()
            ViewController.activityIndicator.isHidden = true
        }
        print(password)
    }
}
