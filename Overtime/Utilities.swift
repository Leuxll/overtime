//
//  Utilities.swift
//  Overtime
//
//  Created by Yue Fung Lee on 12/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield: UITextField) {
        
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.backgroundColor = .black
        textfield.layer.cornerRadius = 10
        
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    

}
