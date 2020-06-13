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
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUpUI() {
        
        setNavBarToTheView()
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    func setNavBarToTheView() {
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Overtime"
        
        if let navigationBar = self.navigationController?.navigationBar {
            let gradient = CAGradientLayer()
            var bounds = navigationBar.bounds
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            gradient.frame = bounds
            gradient.colors = [UIColor(red: 255/255, green: 121/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1).cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)

            if let image = getImageFrom(gradientLayer: gradient) {
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
        }
        
    }
    
    func checkingInputFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields."
            
        }
        
        if passwordTextField.text != confirmPasswordTextField.text {
            
            return "Your passwords does not match."
            
        }
        
        let passwordWithOutSpaces = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(passwordWithOutSpaces) == false {
            
            return "Please make sure your passwords have 8 characters and contains at least 1 special character and number."
            
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = checkingInputFields()
        
        if error != nil {
            
            showError(error!)
            
        } else {
            
           let firstName = firstNameTextField.text!
           let lastName = lastNameTextField.text!
           let email = emailTextField.text!
           let password = passwordTextField.text!
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    self.showError(err!.localizedDescription)
                    
                } else {
                    
                    let db = Firestore.firestore()
                    
                    
                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid": result!.user.uid ]) { (error) in
                        
                        
                        if error != nil {
                            
                            self.showError("User not created")
                            
                        }
                        
                    }
                    
                    self.transition()
                    
                }
                
            }
            
            
        }
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
