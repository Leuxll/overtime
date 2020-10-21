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
    
    static var questions = [Question]()
    static var questionCollectionRef: CollectionReference!
    var documentId = ""
    var string = ""
    
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.questions.append(Question(question: "Test", answer1: "Test", answer2: "Test", answer3: "Test", answer4: "Test", correctAnswer: "Test"))
//        print(questions[0].question)
        
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

        QuestionsViewController.questionCollectionRef = Firestore.firestore().collection("posts").document(documentId).collection("questionAndAnswers")
        
//        displayQuestions()
//        updateQuestion()
        storeQuestions()
    }
        
    func storeQuestions() {
            
                QuestionsViewController.questionCollectionRef.getDocuments { (snapshot, error) in
                        guard let snap = snapshot else {return}
                    
                        for document in snap.documents {
                            let data = document.data()
                            let question = data["question"] as! String
                            let answer1 = data["answer1"] as! String
                            let answer2 = data["answer2"] as! String
                            let answer3 = data["answer3"] as! String
                            let answer4 = data["answer4"] as! String
                            let correctAnswer = data["correctAnswer"] as! String
                            
                            Test.questions.append(Question(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer))
                            self.string = answer1
                        }
                    print(Test.questions)
            
                    }
        print(Test.questions)
        print(string)
        print("Hello")
        }
    
    
    @IBAction func answerPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            print("answer1")
        } else if sender.tag == 2 {
            print("answer2")
        } else if sender.tag == 3 {
            print("answer3")
        } else {
            print("answer4")
        }
    }
    
    func updateQuestion() {
        
    }
    
    func updateUI() {
    
    }
    func restartQuiz() {

    }
    
}
