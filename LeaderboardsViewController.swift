//
//  LeaderboardsViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 16/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

//Structure for the leaderboard user
struct LeaderboardUser {
    
    let firstName: String?
    let points: Int!
    
}

class LeaderboardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Initializing the varibles used within the LeaderboardsViewController
    var users = [LeaderboardUser]()
    var userCollectionRef: CollectionReference!
    
    //Linking UIView Elements outlets to the code from storyboard
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
        tableView.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        tableView.allowsSelection = false
        
        
    }
    
    //Called from viewDidLoad, retreving the database to list out the users in the table view
    func listUser() {
        
        
        userCollectionRef.getDocuments { (snapshot, error) in
            //Trapping any invalid paramters if any
            guard let snap = snapshot else {return}
            
            //For-loop that loops through the documents within the snapshot recieved
            for document in snap.documents {
                //settting each variable to the correct retrieved field
                let data = document.data()
                let firstName = data["firstName"] as? String
                let points = data["points"] as! Int
                //Appending the information above to the array list
                self.users.append(LeaderboardUser(firstName: firstName, points: points))
                //Setting the users array to the merge sorted array
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
                    //Creating a temp variable to store the smaller variable
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
    
    //Setting the tableview up with designated protocals
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Setting the number of items to arrays count
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
        cell.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        return cell
    
       } else {
        
        //if there are no values just return a UITableViewCell()
        return UITableViewCell()
        
        }
        
    }
    
    //Function to create a gradient image for the navigation bar, called from setUpNavBar().
    //Woelmer, Mike, Adding a Gradient Background to UINavigationBar on iOS, Online Article, https://spin.atomicobject.com/2018/06/21/resize-navbar-gradient-ios/
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        //Varaible of gradientImage as UIImage
        var gradientImage:UIImage?
        //Creating a Graphical gradient image through the input of colors and generating an image that can be placed on the navigation bar at the top
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    //Setting up navigation bar
    //Woelmer, Mike, Adding a Gradient Background to UINavigationBar on iOS, Online Article, https://spin.atomicobject.com/2018/06/21/resize-navbar-gradient-ios/
    func setUpNavBar() {
        
        if let navigationBar = self.navigationController?.navigationBar {
            //Defining gradient as a CAGradient
            let gradient = CAGradientLayer()
            //Bounds of the navigationBar
            var bounds = navigationBar.bounds
            //The window of the navigation controller
            let window = UIApplication.shared
                .windows.filter {$0.isKeyWindow}.first
            bounds.size.height += window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            //Setting the gradient frame to the bounds of the navigationbar bounds
            gradient.frame = bounds
            //Selecting the 2 colors that is needed in for the gradient
            gradient.colors = [UIColor(red: 255/255, green: 121/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1).cgColor]
            //Stating the start point and the end points of the gradient to control the direction that the gradient goes at
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)

            //passing the gradient created through the get image function above to create an image with the gradient
            if let image = getImageFrom(gradientLayer: gradient) {
                //setting the image as the backgroundImage of the navigation controller
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
            
            //Create a label
            let label = UILabel()
            //Customizing label
            label.textColor = .white
            label.text = "Leaderboards"
            label.font = UIFont(name: "Poppins-Bold", size: 27)
            //Implementing the label on the left by passing it into a bar button with a custom view
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
            
        }
    
    }

}
