//
//  SignUpViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 13/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting keyboard type to the appropriate one
        emailTextField.keyboardType = .emailAddress
        //Secure entry for password
        passwordTextField.isSecureTextEntry = true
        //Secure entry for confirm password
        confirmPasswordTextField.isSecureTextEntry = true
        //Customization
        setUpUI()
        //Gesture controller to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //When the viewAppear hide
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hide navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //Customizing the user interface
    func setUpUI() {
        
//        setNavBarToTheView()
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleFilledButton(signUpButton)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
//    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
//        var gradientImage:UIImage?
//        UIGraphicsBeginImageContext(gradientLayer.frame.size)
//        if let context = UIGraphicsGetCurrentContext() {
//            gradientLayer.render(in: context)
//            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
//        }
//        UIGraphicsEndImageContext()
//        return gradientImage
//    }
//
//    func setNavBarToTheView() {
//
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.navigationItem.title = "Overtime"
//
//        if let navigationBar = self.navigationController?.navigationBar {
//            let gradient = CAGradientLayer()
//            var bounds = navigationBar.bounds
//            let window = UIApplication.shared
//                .windows.filter {$0.isKeyWindow}.first
//            bounds.size.height += window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//            gradient.frame = bounds
//            gradient.frame = bounds
//            gradient.colors = [UIColor(red: 255/255, green: 121/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1).cgColor]
//            gradient.startPoint = CGPoint(x: 0, y: 1)
//            gradient.endPoint = CGPoint(x: 0, y: 0)
//
//            if let image = getImageFrom(gradientLayer: gradient) {
//                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
//            }
//        }
//
//    }
    
    //Validation of the string, called in sigUpTapped
    func checkingInputFields() -> String? {
        
        //if a field is empty return error
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields."
            
        }
        
        //if password fields do not match
        if passwordTextField.text != confirmPasswordTextField.text {
            
            return "Your passwords does not match."
            
        }
        
        //Keep up the password
        let passwordWithOutSpaces = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Validate password
        if Utilities.isPasswordValid(passwordWithOutSpaces) == false {
            
            //return error
            return "Please make sure your passwords have minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character."
            
        }
        
        //else return nil
        return nil
    }
    
    //Sign up when button is tapped
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Check by called the checking input fields
        let error = checkingInputFields()
        
        if error != nil {
            
            // if there is an error call the showError function to show the message
            showError(error!)
            
        } else {
            
            // create an instance
           let firstName = firstNameTextField.text!
           let lastName = lastNameTextField.text!
           let email = emailTextField.text!
           let password = passwordTextField.text!
            
            //pass the created instance values in to the function
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //if there is an error show it
                if err != nil {
                    
                    self.showError(err!.localizedDescription)
                    
                } else {
                    
                    //Call Firestore
                    let db = Firestore.firestore()
                    
                    //Append new user ot the firestore collection, with random generated ID
                    db.collection("users").document((result?.user.uid)!).setData(["firstName":firstName, "lastName":lastName, "uid": result!.user.uid, "points": 0,"questionsAnswered": 0]) { (error) in
                        
                        
                        if error != nil {
                            
                            //if there is an error show it
                            self.showError("User not created")
                            
                        }
                        
                    }
                    //else Call transition to transition to homescreen
                    self.transition()
                    
                }
                
            }
            
            
        }
    }
    
    //Displaying error for the user when the input is invalid
    func showError(_ message: String) {
        
        //Customizing error for the user when the input is invalid
        errorTextView.text = message
        errorTextView.alpha = 1
        
    }
    
    //Transiiton to the homescreen viewcontroller, called in signUpTapped
    func transition() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    //obj func to end the editing called from viewDidLoad
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
