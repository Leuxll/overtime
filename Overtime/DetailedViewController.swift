//
//  DetailedViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import SDWebImage

class DetailedViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    
    var imageUrl = ""
    var playerName = ""
    var detailedDescription = ""
    var documentId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
        
        textField.text = detailedDescription
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 24.0
        textField.font = UIFont(name: "Poppins-Regular", size: 14)
        textField.textColor = .white
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        playerNameLabel.text = "About " + playerName
        playerNameLabel.font = UIFont(name: "Poppins-Bold", size: 24)
        
        Utilities.styleFilledButton(startButton)
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        let questionViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.questionViewController) as? QuestionViewController
        
        questionViewController?.documentId = self.documentId
        
        view.window?.rootViewController = questionViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? TabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
