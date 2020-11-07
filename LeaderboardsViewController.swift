//
//  LeaderboardsViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

struct LeaderboardUser {
    
    let firstName: String?
    let points: Int!
    
}

class LeaderboardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var users = [LeaderboardUser]()
    var userCollectionRef: CollectionReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionRef = Firestore.firestore().collection("users")
        setUpNavBar()
        listUser()
        tableView.backgroundColor = .black
        tableView.allowsSelection = false
        
        
    }
    
    func listUser() {
        
        userCollectionRef.getDocuments { (snapshot, error) in
            
            guard let snap = snapshot else {return}
            for document in snap.documents {
                
                let data = document.data()
                let firstName = data["firstName"] as? String
                let points = data["points"] as! Int
                
                self.users.append(LeaderboardUser(firstName: firstName, points: points))
                self.users = self.bubbleSort(arr: self.users)
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func bubbleSort(arr: [LeaderboardUser]) -> [LeaderboardUser] {
        var array = arr
        for _ in 0..<array.count - 1 {
            for j in 0..<array.count - 1 {
                if (array[j].points < array [j+1].points) {
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
        }
        return array
    }
    
    func mergeSort (array: [LeaderboardUser]) -> [LeaderboardUser] {
    
        guard array.count > 1 else {
            return array
        }
        
        let leftArray = Array(array[0..<array.count/2])
        let rightArray = Array(array[array.count/2..<array.count])
        
        return merge(left: mergeSort(array: leftArray), right: mergeSort(array: rightArray))
    
    }
    
    func merge(left: [LeaderboardUser], right: [LeaderboardUser]) -> [LeaderboardUser] {
        
        var mergedArray: [LeaderboardUser] = []
        var left = left
        var right  = right
        
        while left.count > 0 && right.count > 0 {
            
            if left.first!.points > right.first!.points {
                mergedArray.append(left.removeFirst())
            } else {
                mergedArray.append(right.removeFirst())
            }
            
        }
        return mergedArray + left + right
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LeaderboardTableViewCell {
            
        cell.firstName.text = users[indexPath.row].firstName
        cell.points.text = String(users[indexPath.row].points) + " points"
        cell.configureCell()
        cell.backgroundColor = .black
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
            let window = UIApplication.shared
                .windows.filter {$0.isKeyWindow}.first
            bounds.size.height += window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
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
