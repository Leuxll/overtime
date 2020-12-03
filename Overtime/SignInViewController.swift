//
//  FirstViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 12/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {
    
    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    
    //Initializing th variables used within the SignInViewController
    var posts = [Post]()
    var postsCollectionRef: CollectionReference!
    
    //Functions to call when view lods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customization
        setUpUI()
        //Setting keyboard type to the appropriate one
        emailTextField.keyboardType = .emailAddress
        //Secure entry for password
        passwordTextField.isSecureTextEntry = true
        //Gesture controller to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //sign in when button is tapped
    //Ching, Chris, Firebase Authentication Tutorial 2020 - Custom iOS Login Page (Swift), YouTube Video, https://www.youtube.com/watch?v=1HN7usMROt8
    @IBAction func signInTapped(_ sender: Any) {
        
        //Setting values to the different varaibles
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        //passing through the email and password to the Auth sign in function
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            //Error handling
            if err != nil {
                
                self.showError(err!.localizedDescription)
                
            } else {
                
                self.transition()
                
            }
            
        }
        
    }
    
    //Customizing the user interface
    func setUpUI() {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        Utilities.styleFilledButton(signInButton)
        
    }
    
    //Displaying error for the user when the input is invalid
    //Ching, Chris, Firebase Authentication Tutorial 2020 - Custom iOS Login Page (Swift), YouTube Video, https://www.youtube.com/watch?v=1HN7usMROt8
    func showError(_ message: String) {
        
        //Customizing the message that is passed
        errorTextView.text = message
        errorTextView.alpha = 1
        
    }
    
    //Transition to the homescreen viewcontroller
    func transition() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    //obj func to end the editing, called from viewDidLoad
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}


