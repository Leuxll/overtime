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
    
    //Array to store all the questions
    static var questions = [Question]()
    
    //Function to customize any TextField that is being passed in
    static func styleTextField(_ textfield: UITextField) {
        
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        textfield.layer.cornerRadius = 10
        textfield.layer.borderWidth = 3
        textfield.layer.borderColor = UIColor.init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).cgColor
        textfield.layer.masksToBounds = true
        
        
    }
    
    //Function to customize any Button that is being passed in
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
    }
    
    //Function to make sure that the password that the user enters matches the requirements
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Function to customize the difficulty label in the profileview
    static func difficultyLabel(_ label:UILabel) {
        
        label.backgroundColor = UIColor(red: 109/255, green: 212/255, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 14.0
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Poppins-Bold", size: 12)
        
    }
    
    //Function to customize the points label in the profileview
    static func pointsLabel(_ label:UILabel) {
        
        label.backgroundColor = UIColor(red: 247/255, green: 181/255, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 14.0
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Poppins-Bold", size: 12)
        
    }
    
    //Function to customize the points label in the profileview
    static func cellLabels(_ label:UILabel) {
        
        label.font = UIFont(name: "Poppins-Bold", size: 20)
        label.textColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        
    }

}
