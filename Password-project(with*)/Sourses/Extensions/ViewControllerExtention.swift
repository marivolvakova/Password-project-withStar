//
//  TextFieldExtension.swift
//  Password-project(with*)
//
//  Created by Мария Вольвакова on 15.07.2022.
//

import UIKit


extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }
}
