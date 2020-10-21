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

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var questionDoneLabel: UILabel!
    @IBOutlet weak var numOfQuestionDone: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var numOfTotalPoints: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var questionDoneImage: UILabel!
    @IBOutlet weak var totalPointsImage: UILabel!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        let usersRef = db.collection("users").document(Auth.auth().currentUser!.uid)

        usersRef.getDocument { (document, err) in
            let firstName = document?.get("firstName")
            let totalPoints : Int = document?.get("points") as! Int
            let questionsAnswered : Int = document?.get("questionsAnswered") as! Int
            self.userNameLabel.text = firstName as? String
            self.numOfQuestionDone.text = String(questionsAnswered)
            self.numOfTotalPoints.text = String(totalPoints)
        }
        
        setUpPointsLabels()
        setUpUsernameLabel()
        setUpQuestionsLabels()
        setUpDeleteAccountButton()
        setUpNavBar()
        Utilities.styleFilledButton(signOutButton)
        
        
    }
    
    func setUpPointsLabels() {
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "sharp_star_rate_white_48pt.png")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        self.totalPointsImage.attributedText = completeText
        self.totalPointsImage.textAlignment = .center
        self.totalPointsImage.textColor = .white
        
        totalPointsImage.backgroundColor = UIColor(red: 247/255, green: 181/255, blue: 0/255, alpha: 1)
        totalPointsImage.layer.cornerRadius = 42.0
        totalPointsImage.layer.masksToBounds = true
        totalPointsLabel.textColor = UIColor(red: 247/255, green: 181/255, blue: 0/255, alpha: 1)
        totalPointsLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        totalPointsLabel.text = "Total Points"
        totalPointsLabel.textAlignment = .center
        numOfTotalPoints.textColor = .white
        numOfTotalPoints.font = UIFont(name: "Poppins-Bold", size: 20)
        numOfTotalPoints.textAlignment = .center
        
    }
    
    func setUpQuestionsLabels() {
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "sharp_equalizer_white_48pt.png")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        self.questionDoneImage.attributedText = completeText
        self.questionDoneImage.textAlignment = .center
        self.questionDoneImage.textColor = .white
        
        
        questionDoneImage.backgroundColor = UIColor(red: 109/255, green: 212/255, blue: 0/255, alpha: 1)
        questionDoneImage.layer.cornerRadius = 42.0
        questionDoneImage.layer.masksToBounds = true
        questionDoneLabel.textColor = UIColor(red: 109/255, green: 212/255, blue: 0/255, alpha: 1)
        questionDoneLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        questionDoneLabel.text = "Questions"
        questionDoneLabel.textAlignment = .center
        numOfQuestionDone.textColor = .white
        numOfQuestionDone.font = UIFont(name: "Poppins-Bold", size: 20)
        numOfQuestionDone.textAlignment = .center
        
    }
    
    func setUpUsernameLabel() {
        
        userNameLabel.font = UIFont(name: "Poppins-Bold", size: 45)
        userNameLabel.textColor = .white
        
    }
    
    func setUpDeleteAccountButton() {
        
        deleteAccountButton.tintColor = .red
        deleteAccountButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 10)
        
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
    
    func setUpNavBar() {
        
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
            
            let label = UILabel()
            label.textColor = .white
            label.text = "Profile"
            label.font = UIFont(name: "Poppins-Bold", size: 27)
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
            
        }
    
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Signout of your account?", message: "Are you sure you want to signout of your account?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            try! Auth.auth().signOut()
            let signInViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? SignInViewConttroller
            
            self.view.window?.rootViewController = signInViewController
            self.view.window?.makeKeyAndVisible()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete your account?", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            
            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).delete { (error) in
                
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
                
            }
            
            let user = Auth.auth().currentUser
            
            user?.delete(completion: { (error) in
                
                if let error = error {
                    
                    print(error)
                    
                } else {
                    
                    print("user deleted")
                    
                }
                
                let signInViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? SignInViewConttroller
                
                self.view.window?.rootViewController = signInViewController
                self.view.window?.makeKeyAndVisible()
                
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true)
        
    }

}
