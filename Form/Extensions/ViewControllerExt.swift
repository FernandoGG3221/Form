//
//  ViewControllerExt.swift
//  Form
//
//  Created by Fernando González González on 17/02/22.
//

import Foundation
import UIKit

extension ViewController{
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateString(text:String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", "[A-Za-z]{2,}" ).evaluate(with: text)
    }
    
    func validateNumber(number:String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", "\\d{10}").evaluate(with: number)
    }
    
    func validateEmail(email:String) -> Bool{
        let reg = "[A-Z0-9a-z]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", reg)
        return test.evaluate(with: email)
    }
    
    
}
