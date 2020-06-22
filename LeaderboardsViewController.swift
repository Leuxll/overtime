//
//  LeaderboardsViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var users = [User]()
    var userCollectionRef: CollectionReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionRef = Firestore.firestore().collection("users")
        
        setUpNavBar()
        listUser()
        
        tableView.backgroundColor = .black
        
    }
    
    func listUser() {
        
        userCollectionRef.order(by: "points", descending: true).getDocuments { (snapshot, error) in
            
            guard let snap = snapshot else {return}
            for document in snap.documents {
                
                let data = document.data()
                let firstName = data["firstName"] as? String
                let lastName = data["lastName"] as? String
                let points = data["points"] as! Int
                let questionsAnswered = data["questionsAnswered"] as! Int
                
                self.users.append(User(firstName: firstName, lastName: lastName, points: points, questionsAnswered: questionsAnswered))
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LeaderboardTableViewCell {
            
        cell.firstName.text = users[indexPath.row].firstName
        cell.points.text = String(users[indexPath.row].points) + " points"
        cell.configureCell()
        return cell
    
       } else {
        
        return UITableViewCell()
        
        }
        
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
            label.text = "Leadeboards"
            label.font = UIFont(name: "Poppins-Bold", size: 27)
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
            
        }
    
    }

}
