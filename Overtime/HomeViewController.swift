//
//  HomeViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 13/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //Linking UIView Elements outlets to the code from storyboard
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Initializing the varibles used within the HomeViewController
    var posts =  [Post]()
    var postsCollectionRef: CollectionReference!
    var usersCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the delegate and dataSource to itself
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Customization
        setUpNavBar()
        
        //Reference to the collection reference path that stores the posts
        postsCollectionRef = Firestore.firestore().collection("posts")
        
        //Listing the post
        listPost()
        
        //Making sure the Utilites.question is cleared when the user returns to the homescrren after a quiz
        Utilities.questions.removeAll()
        
        
    }
    
    //Called from viewDidLoad, retreving the database to list out he users in the collection view
    func listPost() {
        
        postsCollectionRef.getDocuments { (snapshot, error) in
            
            //Trapping any invalid parameters if any
            guard let snap = snapshot else {return}
            
            //For-loop that loops through documents within the snapshot
            for document in snap.documents {
                
                //setting each variable to the correct retrived field
                let data = document.data()
                let playerName = data["playerName"] as! String
                let difficulty = data["difficulty"] as! String
                let imageUrl = data["imageUrl"] as! String
                let description = data["description"] as! String
                let points = data["points"] as! String
                let documentId = document.documentID
                
                //Appednging the information above to the array list
                self.posts.append(Post(imageUrl: imageUrl, playerName: playerName, points: points, difficulty: difficulty, description: description, documentId: documentId))
                //Reloading the collectionView to show the correct data
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    //Setting the collectionView up with designated protrocals
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Setting the number of items to arrays count
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Populating the set numberOfRows with cells of information
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PostCell {
            
            //Setting each of the items in teh cell to the appropriate value
            cell.imageView.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
            cell.difficultyLabel.text = posts[indexPath.row].difficulty
            cell.nameLabel.text = posts[indexPath.row].playerName
            cell.pointsLabel.text = posts[indexPath.row].points
            //Customizing the cells
            cell.configureCell()
            return cell
            
        } else {
            
            //if no values just return UICollectionViewCell()
            return UICollectionViewCell()
            
        }
        
    }
    //Function to create a gradient image for the navigation bar, called from setUpNavBar()
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
            let nameOfScreen = UILabel()
            //Customizing label
            nameOfScreen.textColor = .white
            nameOfScreen.text = "Welcome"
            nameOfScreen.font = UIFont(name: "Poppins-Bold", size: 27)
            //Implementing the label on the left by passing it into a bar button with a custom view
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: nameOfScreen)
            
        }
    
    }
    
    //When the individual cards are selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Initiating the detailedViewController that would be segued once the cards are tapped on
        let detailViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailedViewController) as! DetailedViewController
        
        //Transferring data with through the segue
        detailViewController.imageUrl = posts[indexPath.row].imageUrl!
        detailViewController.detailedDescription = posts[indexPath.row].description!
        detailViewController.playerName = posts[indexPath.row].playerName!
        detailViewController.documentId = posts[indexPath.row].documentId!
        
        //Making the DetailedViewControllerview visible to the user
        view.window?.rootViewController = detailViewController
        view.window?.makeKeyAndVisible()
        
    }

}
