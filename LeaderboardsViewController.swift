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

    //Initializing the varibles used within the LeaderboardsViewController
    var users = [LeaderboardUser]()
    var userCollectionRef: CollectionReference!
    
    //Linking UIView Elements outlets to the code from storybooard
    @IBOutlet weak var tableView: UITableView!
    
    //Functions to call when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reference to the collection reference path that stores the users
        userCollectionRef = Firestore.firestore().collection("users")
        //Calling the setUpNavBar Function
        setUpNavBar()
        //Listing the users
        listUser()
        //Setting properties of the tableView
        tableView.backgroundColor = .black
        tableView.allowsSelection = false
        
        
    }
    
    //Called from viewDidLoad, retreving the database to list out the users in the table view
    func listUser() {
        
        
        userCollectionRef.getDocuments { (snapshot, error) in
            //Trapping any invalid paramters if any
            guard let snap = snapshot else {return}
            
            //For-loop that loops through the docuemnts within the snapshot recieved
            for document in snap.documents {
                //settting each variable to the correct retreived field
                let data = document.data()
                let firstName = data["firstName"] as? String
                let points = data["points"] as! Int
                //Appending the information above the the array list
                self.users.append(LeaderboardUser(firstName: firstName, points: points))
                //Setting the users array to the bubble sorted array
                self.users = self.bubbleSort(arr: self.users)
                //Reloading the tableview to reflect the sorted users according to points
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    //bubble sorting function called when retrieving the appending the array
    func bubbleSort(arr: [LeaderboardUser]) -> [LeaderboardUser] {
        var array = arr
        //For-loop to loop throught the array count from 0 to array.count - 1
        for _ in 0..<array.count - 1 {
            //Second-loop to find the second index
            for j in 0..<array.count - 1 {
                //Comparing the 2 points at the index, if the second one is larger then perfom a swap as we want it in descending order with the highest value at the top
                if (array[j].points < array [j+1].points) {
                    //Creating a temperary variable to store the smaller variable
                    let temp = array[j]
                    //switching the variables
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
        }
        //returning the new sorted array
        return array
    }
    
//    func mergeSort (array: [LeaderboardUser]) -> [LeaderboardUser] {
//
//        guard array.count > 1 else {
//            return array
//        }
//
//        let leftArray = Array(array[0..<array.count/2])
//        let rightArray = Array(array[array.count/2..<array.count])
//
//        return merge(left: mergeSort(array: leftArray), right: mergeSort(array: rightArray))
//
//    }
//
//    func merge(left: [LeaderboardUser], right: [LeaderboardUser]) -> [LeaderboardUser] {
//
//        var mergedArray: [LeaderboardUser] = []
//        var left = left
//        var right  = right
//
//        while left.count > 0 && right.count > 0 {
//
//            if left.first!.points > right.first!.points {
//                mergedArray.append(left.removeFirst())
//            } else {
//                mergedArray.append(right.removeFirst())
//            }
//
//        }
//        return mergedArray + left + right
//
//    }
    
    //Setting the tableview up with designated protocals
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Populating the table rowsa by getting the count of the array
        users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Populating the set numberOfRows with cells of information
       if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LeaderboardTableViewCell {
        
        //Setting each of the items in the cell to the appropriate value
        cell.firstName.text = users[indexPath.row].firstName
        cell.points.text = String(users[indexPath.row].points) + " points"
        //customizing the cells
        cell.configureCell()
        cell.backgroundColor = .black
        return cell
    
       } else {
        
        //if there are no values just return a UITableViewCell()
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
