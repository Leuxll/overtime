//
//  DetailedViewController.swift
//  Overtime
//
//  Created by YFL on 16/6/2020.
//  Copyright © 2020 YFL. All rights reserved.
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
    
    //Initializing the varibles used within the DetailedViewController.
    var questionCollectionRef: CollectionReference!
    var imageUrl = ""
    var playerName = ""
    var detailedDescription = ""
    var documentId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Reference to the collection reference path that stores the questionAndAnswers
        questionCollectionRef = Firestore.firestore().collection("posts").document(documentId).collection("questionAndAnswers")
        //When the image is not yet retreived from the database show a placeholderImage
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
        //Calling functions for customization purposes
        Utilities.styleFilledButton(startButton)
        customLabel()
        customTextField()
        //Grabbing the question entries from the database
        fetchQuestions()
        
    }
    
    //Called from viewDidLoad, styling of label
    func customLabel() {
        
        playerNameLabel.text = "About " + playerName
        playerNameLabel.font = UIFont(name: "Poppins-Bold", size: 24)
        
    }
    
    //Styling of TextField
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
    
    //Grabbing the questions and mutliple choice questions from the database
    func fetchQuestions() {
        questionCollectionRef.getDocuments { (snapshot, error) in
            //Trapping any invalid parameters if any
            guard let snap = snapshot else {return}
            //For-loop to loops through the docments within the snapshot received
            for document in snap.documents {
                //setting each variable to the correct field
                let data = document.data()
                let question = data["question"] as! String
                let answer1 = data["answer1"] as! String
                let answer2 = data["answer2"] as! String
                let answer3 = data["answer3"] as! String
                let answer4 = data["answer4"] as! String
                let correctAnswer = data["correctAnswer"] as! Int
                
                //Appending the above retreived information to Utilties.question with a structure of Question
                Utilities.questions.append(Question(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer))
                
            }
            
        }
    }
    
    //Shuffling the array, so that question appear in different order, setting parameters that needs to be passed in as an array with the structure of Question.
    //Wooding, Victor, Shuffle an Array in Swift 4, YouTube Video, https://www.youtube.com/watch?v=5hlw-KGfXtY&feature=youtu.be
    func shuffleQuestions(arrayToBeShuffled array1: [Question]) {
        
        //Initializing different variables
        var oldArray = array1
        var newArray = [Question]()
        var randomNumber: Int
        
        //For-loop to iterate throught array1
        for _ in array1 {
            //Generates a random number that is equal to oldArray's length, however it includes 0, therefore has to -1
            randomNumber = Int(arc4random_uniform((UInt32(oldArray.count - 1))))
            //Appending the element from old array with the random generated index number to new array
            newArray.append(oldArray[randomNumber])
            //removing that array item
            oldArray.remove(at: randomNumber)
        }
        //setting the Utilties.questions array that we were pulling from to the newArray
        Utilities.questions = newArray
        
    }
    
    //Actions that occur when the startButton is tapped
    @IBAction func startButtonTapped(_ sender: Any) {
        
        var arrayIsEmpty = true
        //When the array is empty is true then it loops through if not it just skips the function when called
        while arrayIsEmpty == true {
            //Checks to see if the array is empty
            if Utilities.questions.isEmpty != true {
                shuffleQuestions(arrayToBeShuffled: Utilities.questions)
                let questionViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.questionViewController) as? QuestionsViewController
            
                questionViewController?.quizName = playerName + " Quiz"
                
                view.window?.rootViewController = questionViewController
                view.window?.makeKeyAndVisible()
                arrayIsEmpty = false
            
            }
        }
    }
    
    //When the back button within this viewcontroller is pressed it would dismiss this viewcontroller and switch the view back to the homescreen. This calls the id from the Constants class.
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
