//
//  questionViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 19/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

class QuestionsViewController: UIViewController {
    

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!

    let allQuestions = Utilities.questions
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    var totalPoints: Int = 0
    var questionsAnswered: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleFilledButton(answer1Button)
        Utilities.styleFilledButton(answer2Button)
        Utilities.styleFilledButton(answer3Button)
        Utilities.styleFilledButton(answer4Button)
        
        questionTextView.textColor = .white
        questionTextView.font = UIFont(name: "Poppins-Bold", size: 30)
        questionTextView.textAlignment = .center
        questionTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        questionTextView.backgroundColor = .black
        questionTextView.layer.cornerRadius = 24.0
        
        updateQuestion()
        
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        if sender.tag == selectedAnswer {
            print("correct")
            score += 1
            print(score)
        } else {
            print("wrong")
        }
        questionNumber += 1
        updateQuestion()
    }
    
    func updateQuestion() {
        
        if questionNumber <= Utilities.questions.count - 1 {
            
            questionTextView.text = allQuestions[questionNumber].question
            answer1Button.setTitle(allQuestions[questionNumber].answer1, for: .normal)
            answer2Button.setTitle(allQuestions[questionNumber].answer2, for: .normal)
            answer3Button.setTitle(allQuestions[questionNumber].answer3, for: .normal)
            answer4Button.setTitle(allQuestions[questionNumber].answer4, for: .normal)
            selectedAnswer = Utilities.questions[questionNumber].correctAnswer
            
        } else {
            let alert = UIAlertController(title: "Finished", message: "End of Quiz. Your score is: " + String(score), preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Return Home", style: .default, handler: { action in
//                    self.updatingUserInfo()
                    self.returnHome()})
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
//    func updatingUserInfo() {
//        let currentUser = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
//        currentUser.getDocument { [self] (document, err) in
//            let points : Int = document?.get("points") as! Int
//            let question: Int = document?.get("questionsAnswered") as! Int
//            
//            self.totalPoints += self.score
//            self.questionsAnswered += self.allQuestions.count
//            
//            print(self.totalPoints)
//            print(self.questionsAnswered)
//        }
//        
////        currentUser.updateData(["points": totalPoints, "questionsAnswered": questionsAnswered])
////        print("update")
//        
//    }
    
    func returnHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        questionNumber = 0
        score = 0
        Utilities.questions.removeAll()
//        print("home")
    }

}
