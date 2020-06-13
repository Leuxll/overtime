//
//  FirstViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 12/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewConttroller: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            if err != nil {
                
                self.showError(err!.localizedDescription)
                
            } else {
                
                self.transition()
                
            }
            
        }
        
    }
    
    func setUpUI() {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        Utilities.styleFilledButton(signInButton)
        
    }
    
    func showError(_ message: String) {
        
        errorTextView.text = message
        errorTextView.alpha = 1
        
    }
    
    func transition() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? tabBarViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
}


