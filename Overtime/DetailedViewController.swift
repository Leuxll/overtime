//
//  DetailedViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import NVActivityIndicatorView

class DetailedViewController: UIViewController {

    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Initializing the varibles used within the DetailedViewController
    var questionCollectionRef: CollectionReference!
    var imageUrl = ""
    var playerName = ""
    var detailedDescription = ""
    var documentId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionCollectionRef = Firestore.firestore().collection("posts").document(documentId).collection("questionAndAnswers")
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
        Utilities.styleFilledButton(startButton)
        customLabel()
        customTextField()
        fetchQuestions()
        
    }
    
    func customLabel() {
        
        playerNameLabel.text = "About " + playerName
        playerNameLabel.font = UIFont(name: "Poppins-Bold", size: 24)
        
    }
    
    func customTextField() {
        
        textField.text = detailedDescription
        textField.layer.cornerRadius = 24.0
        textField.font = UIFont(name: "Poppins-Regular", size: 14)
        textField.textColor = .white
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textField.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).cgColor
        
    }
    
    func fetchQuestions() {
        questionCollectionRef.getDocuments { (snapshot, error) in
            guard let snap = snapshot else {return}
            
            for document in snap.documents {
                let data = document.data()
                let question = data["question"] as! String
                let answer1 = data["answer1"] as! String
                let answer2 = data["answer2"] as! String
                let answer3 = data["answer3"] as! String
                let answer4 = data["answer4"] as! String
                let correctAnswer = data["correctAnswer"] as! Int
                
                Utilities.questions.append(Question(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer))
                
            }
            
        }
    }
    
    func shuffleQuestions(arrayToBeShuffled array1: [Question]) {
        
        var oldArray = array1
        var newArray = [Question]()
        var randomNumber: Int
        
        for _ in array1 {
            randomNumber = Int(arc4random_uniform((UInt32(oldArray.count - 1))))
            newArray.append(oldArray[randomNumber])
            oldArray.remove(at: randomNumber)
        }
        
        newArray = Utilities.questions
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        var arrayIsEmpty = true
        
        while arrayIsEmpty == true {
            
            if Utilities.questions.isEmpty != true {
                shuffleQuestions(arrayToBeShuffled: Utilities.questions)
                let questionViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.questionViewController) as? QuestionsViewController
            
                view.window?.rootViewController = questionViewController
                view.window?.makeKeyAndVisible()
                arrayIsEmpty = false
            
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
