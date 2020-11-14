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
    
    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!

    //Initializing the varibles used within the QuestionViewController
    var allQuestions = Utilities.questions
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    var totalPoints: Int = 0
    var questionsAnswered: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Calling the Utilites.styleFilledButton to customize the buttons to the way my client wants them. Also, calling updateQuestion functions when the view of this viewcontroller appears on the phone.
        Utilities.styleFilledButton(answer1Button)
        Utilities.styleFilledButton(answer2Button)
        Utilities.styleFilledButton(answer3Button)
        Utilities.styleFilledButton(answer4Button)
        customTextView()
        updateQuestion()
        
    }
    
    //This function is for customization the TextView and changing its different properties
    func customTextView() {
        
        questionTextView.textColor = .white
        questionTextView.font = UIFont(name: "Poppins-Bold", size: 30)
        questionTextView.textAlignment = .center
        questionTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        questionTextView.layer.cornerRadius = 24.0
        questionTextView.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        questionTextView.layer.borderWidth = 3
        questionTextView.layer.borderColor = UIColor.init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).cgColor
        
    }
    
    //This is an IBAction function that links to when the button is pressed it would perform a certain action. In this case, it would be if the user clicks on the button that has the same value as correctAnswer than it would add a point to the score variable. Then it would proceed to add one to the questionNumber and update the questions for it to show the next one.
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
    
    // This function is used after the user answers a question until there is no more quetions left in the array. This function with the combination above is going to iterate through all theallQuetions veriable which is an array from Utiltiies called questions. Then if the function finishes iterating through the array and the questionNuber is larger, it would prompt the user with an alert saying the the quiz is finished and then from this the button that is provided will prompt the user to go back to the homescreen and add the corresponding points to the users account
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
                    self.updatingUserInfo()
                    self.returnHome()})
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    //This is one of the functions that gets called within updateQuestion, this is the function that communicates with firebase by grabbing the current user's id and looking through firebase to first retreive the scores and the questions answered of that ceratin user then, we would add the score that the user acheived in the current quiz and update that certain document.
    func updatingUserInfo() {
        let currentUser = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        currentUser.getDocument { [self] (document, err) in
            var points : Int = document?.get("points") as! Int
            var question: Int = document?.get("questionsAnswered") as! Int
            
            points += score
            question += allQuestions.count
            print(points, question)
            
            currentUser.updateData(["points" : points, "questionsAnswered" : question]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            
        }
        
    }
}
    
    // This function is another function that gets called in updateQuestion when there is no more questions to present to the user within that quiz. By calling this function it would return to the homescreen of the application.
    func returnHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()

    }
}
