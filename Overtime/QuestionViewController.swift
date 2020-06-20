//
//  questionViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 19/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    var questions = [Question]()
    private var questionCollectionRef: CollectionReference!
    var documentId = ""
    
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    
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

        questionCollectionRef = Firestore.firestore().collection("posts").document(documentId).collection("questionAndAnswers")
        
        displayQuestions()
        updateQuestion()
        
    }
    
    func displayQuestions() {
        
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
                let documentId = document.documentID
                
                self.questions.append(Question(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer))
                
            }
            
            
        }
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if sender.tag == selectedAnswer {
            
            print("correct")
            score += 1
            
        } else {
            
            print("wrong")
            
        }
        self.questionNumber += 1
        updateQuestion()
        
    }
    
    func updateQuestion() {
        
//        if questionNumber < questions.count {
            
            questionTextView.text = questions[questionNumber].question
            answer1Button.setTitle(questions[questionNumber].answer1, for: UIControl.State.normal)
            answer2Button.setTitle(questions[questionNumber].answer2, for: UIControl.State.normal)
            answer3Button.setTitle(questions[questionNumber].answer3, for: UIControl.State.normal)
            answer4Button.setTitle(questions[questionNumber].answer4, for: UIControl.State.normal)
            selectedAnswer = questions[questionNumber].correctAnswer
        
        print(questions)
            
//        } else {
//
//            let alert = UIAlertController(title: "Awesome", message: "End of quiz.", preferredStyle: .alert)
//            let returnAction = UIAlertAction(title: "Return to Homescreen", style: .default, handler: {action in self.returnHome()})
//            alert.addAction(returnAction)
//            self.present(alert, animated: true, completion: nil)
//
//
//        }
        
    }
    
    func updateUI() {
        
        
        
    }
    
    func returnHome() {
        
    }
    
}
