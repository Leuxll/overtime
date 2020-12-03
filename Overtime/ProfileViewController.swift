//
//  ProfileViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {


    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var questionDoneImage: UILabel!
    @IBOutlet weak var totalPointsImage: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var questionDoneLabel: UILabel!
    @IBOutlet weak var numOfQuestionDone: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var numOfTotalPoints: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!

    //Initializing the variables used within the ProfileViewController
    var userDocumentReference: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionDoneLabel.sizeToFit()
        numOfQuestionDone.sizeToFit()
        //Reference to the specific document reference path that store the current users information
        userDocumentReference = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        //Calling the customization label
        setUpPointsLabels()
        setUpUsernameLabel()
        setUpQuestionsLabels()
        setUpDeleteAccountButton()
        setUpNavBar()
        Utilities.styleFilledButton(signOutButton)
        //Calling the function to actually fetch the data of the current user
        fetchUserInfo()
        
    }
    
    //Function called in viewDidLoad
    func fetchUserInfo() {
        //
        userDocumentReference.getDocument { (document, error) in
            //Setting each variable to the correct field
            let firstName = document?.get("firstName")
            let totalPoints : Int = document?.get("points") as! Int
            let questionsAnswered : Int = document?.get("questionsAnswered") as! Int
            self.userNameLabel.text = firstName as? String
            self.numOfQuestionDone.text = String(questionsAnswered)
            self.numOfTotalPoints.text = String(totalPoints)
        }
    }
    
    //Function called in viewDidLaod
    func setUpPointsLabels() {

        //Creating a new NSTextAttachment object
        let imageAttachment = NSTextAttachment()
        //Setting the objects image to the points image that is used
        imageAttachment.image = UIImage(named: "sharp_star_rate_white_48pt.png")
        //Creaing a new NSAttributedString with the attachment of NSTextAttachment that was just created
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //As we do not want any text, we are just going to create a NsMutableAttributedString with no words
        let completeText = NSMutableAttributedString(string: "")
        //Append the attachmentString created to the text
        completeText.append(attachmentString)
        //Setting the label to the completeText that we created
        totalPointsImage.attributedText = completeText

        //Customizations the image label
        totalPointsImage.textAlignment = .center
        totalPointsImage.textColor = .white
        totalPointsImage.backgroundColor = UIColor(red: 247/255, green: 181/255, blue: 0/255, alpha: 1)
        totalPointsImage.layer.cornerRadius = 50.0
        totalPointsImage.layer.masksToBounds = true
        
        //Customizing the textlabel of "Total Points"
        totalPointsLabel.textColor = UIColor(red: 247/255, green: 181/255, blue: 0/255, alpha: 1)
        totalPointsLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        totalPointsLabel.text = "Total Points"
        totalPointsLabel.textAlignment = .center
        
        //Customizing the label that displays the # of point
        numOfTotalPoints.textColor = .white
        numOfTotalPoints.font = UIFont(name: "Poppins-Bold", size: 16)
        numOfTotalPoints.textAlignment = .center
        
    }
    
    func setUpQuestionsLabels() {
        
        //Repeating what is done in the setUpPointsLabel, this time for the totalQuetionsAnsweredLabel
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "sharp_equalizer_white_48pt")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        questionDoneImage.attributedText = completeText

        //Customizing the image label
        questionDoneImage.textAlignment = .center
        questionDoneImage.textColor = .white
        questionDoneImage.backgroundColor = UIColor(red: 109/255, green: 212/255, blue: 0/255, alpha: 1)
        questionDoneImage.layer.cornerRadius = 50.0
        questionDoneImage.layer.masksToBounds = true
        questionDoneLabel.textColor = UIColor(red: 109/255, green: 212/255, blue: 0/255, alpha: 1)
        
        //Customizing the textlabel of "Total Question Done"
        questionDoneLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        questionDoneLabel.text = "Questions"
        questionDoneLabel.textAlignment = .center
        
        //Customizing the label that displays the # of answers done
        numOfQuestionDone.textColor = .white
        numOfQuestionDone.font = UIFont(name: "Poppins-Bold", size: 16)
        numOfQuestionDone.textAlignment = .center
        
    }
    
    //Called in viewDidLoad
    func setUpUsernameLabel() {
        
        //Customizations of the delete button
        userNameLabel.font = UIFont(name: "Poppins-Bold", size: 45)
        userNameLabel.textColor = .white
        
    }
    
    //Called in viewDidLoad
    func setUpDeleteAccountButton() {
        
        //Customizations of the delete button
        deleteAccountButton.tintColor = .red
        deleteAccountButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 10)
        
    }
    
    //Function to create a gradient image for th navigation bar, called from setUpNavBar
    //Woelmer, Mike, Adding a Gradient Background to UINavigationBar on iOS, Online Article, https://spin.atomicobject.com/2018/06/21/resize-navbar-gradient-ios/
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        //Variabkle of gradientImage as UIImage
        var gradientImage:UIImage?
        //Creating a Graphical gradient image through the input of colors and generating and image that can be placed on the navigation bar at the top
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    //Setting up navigation bar
    //Woelmer, Mike, Adding a Gradient Background to UINavigationBar on iOS, Online Article, https://spin.atomicobject.com/2018/06/21/resize-navbar-gradient-ios/
    func setUpNavBar() {
        
        if let navigationBar = self.navigationController?.navigationBar {
            //Defining gradient as a CAGradient
            let gradient = CAGradientLayer()
            //Bounds of the navigationBar
            var bounds = navigationBar.bounds
            //The window of the navigation controller
            let window = UIApplication.shared
                .windows.filter {$0.isKeyWindow}.first
            bounds.size.height += window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            //Setting the gradient frame to the bounds of the navigationbar bounds
            gradient.frame = bounds
            //Selecting the 2 colors that is needed in for the gradient
            gradient.colors = [UIColor(red: 255/255, green: 121/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1).cgColor]
            //Stating the start point and the end points of the gradient to control the direction that the gradient goes at
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)

            //passing gradient created to get image function above to create an image with the gradient
            if let image = getImageFrom(gradientLayer: gradient) {
                //setting the image as the backgroundImage of the navigation controller
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
            
            //Create a label
            let label = UILabel()
            //Customizing label
            label.textColor = .white
            label.text = "Profile"
            label.font = UIFont(name: "Poppins-Bold", size: 27)
            //Implementing the label on the left by passing it into a bar button with a custom view
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
            
        }
    
    }
    
    //sign out when button is tapped
    @IBAction func signOutTapped(_ sender: Any) {
        
        //Create and alert to warn the user and confirm if want to signout
        let alert = UIAlertController(title: "Signout of your account?", message: "Are you sure you want to signout of your account?", preferredStyle: .actionSheet)
        //Create option for Yes
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            //Firebase authentication signout
            try! Auth.auth().signOut()
            //Segue to LoginViewController
            let signInViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? SignInViewController
            
            self.view.window?.rootViewController = signInViewController
            self.view.window?.makeKeyAndVisible()
        }))
        
        //Create option for cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //Dismiss the Alert
            self.dismiss(animated: true, completion: nil)
        }))
        //Present the alert
        self.present(alert, animated: true)
        
    }
    
    //delete account when button is tapped
    @IBAction func deleteAccountTapped(_ sender: Any) {
        
        //create and alert to warn the user and cofirm if they want to delete the account
        let alert = UIAlertController(title: "Delete your account?", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .actionSheet)
        //Create option for yes
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            //Access the Firebase database using the current users uid and delete that document from the users collection
            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).delete { (error) in
                //Error handling
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
                
            }
            
            //Delete the user from authentication
            let user = Auth.auth().currentUser
            
            user?.delete(completion: { (error) in
                
                //error handling
                if let error = error {
                    
                    print(error)
                    
                } else {
                    
                    print("user deleted")
                    
                }
                
                //Segue the user back to the login screen
                let signInViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? SignInViewController
                
                self.view.window?.rootViewController = signInViewController
                self.view.window?.makeKeyAndVisible()
                
                
            })
            
        }))
        //Create option for cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.dismiss(animated: true, completion: nil)}))
        //Dismiss alert
        self.present(alert, animated: true)
        
    }

}
