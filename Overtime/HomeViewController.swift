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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //Initializing the varibles used within the HomeViewController
    var posts =  [Post]()
    var postsCollectionRef: CollectionReference!
    
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
        
        view.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        segmentControl.backgroundColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        segmentControl.selectedSegmentTintColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.init(name: "Poppins-Bold", size: 12)]
        segmentControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        segmentControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        
    }
    
    //Called from viewDidLoad, retreving the database to list out the users in the collection view
    func listPost() {
        
        postsCollectionRef.getDocuments { (snapshot, error) in
            
            //Trapping any invalid parameters if any
            guard let snap = snapshot else {return}
            
            //For-loop that loops through documents within the snapshot
            for document in snap.documents {
                
                //setting each variable to the correct retrieved field
                let data = document.data()
                let playerName = data["playerName"] as! String
                let difficulty = data["difficulty"] as! String
                let imageUrl = data["imageUrl"] as! String
                let description = data["description"] as! String
                let points = data["points"] as! String
                let type  = data["type"] as! String
                let documentId = document.documentID
                
                //Appending the information above to the array list
                self.posts.append(Post(imageUrl: imageUrl, playerName: playerName, points: points, difficulty: difficulty, description: description, documentId: documentId, type: type))
                //Reloading the collectionView to show the correct data
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    //Setting the collectionView up with designated protrocals
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Setting the number of items to arrays count
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return posts.count
        case 1:
            let byPlayer = posts.filter({ return $0.type == "player"})
            return byPlayer.count
        case 2:
            let byTeam = posts.filter({ return $0.type == "team"})
            return byTeam.count
        default:
            break
        }
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Populating the set numberOfRows with cells of information
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PostCell {
            
            //Setting each of the items in the cell to the appropriate value
            switch segmentControl.selectedSegmentIndex {
            case 0:
                cell.imageView.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
                cell.difficultyLabel.text = posts[indexPath.row].difficulty
                cell.nameLabel.text = posts[indexPath.row].playerName
                cell.pointsLabel.text = posts[indexPath.row].points
                //Customizing the cells
                cell.configureCell()
            case 1:
                let byPlayer = posts.filter({ return $0.type == "player"})
                cell.imageView.sd_setImage(with: URL(string: byPlayer[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
                cell.difficultyLabel.text = byPlayer[indexPath.row].difficulty
                cell.nameLabel.text = byPlayer[indexPath.row].playerName
                cell.pointsLabel.text = byPlayer[indexPath.row].points
                //Customizing the cells
                cell.configureCell()
            case 2:
                let byTeam = posts.filter({ return $0.type == "team"})
                cell.imageView.sd_setImage(with: URL(string: byTeam[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
                cell.difficultyLabel.text = byTeam[indexPath.row].difficulty
                cell.nameLabel.text = byTeam[indexPath.row].playerName
                cell.pointsLabel.text = byTeam[indexPath.row].points
                //Customizing the cells
                cell.configureCell()
            default:
                break
            }
            
            return cell
            
        } else {
            
            //if no values just return UICollectionViewCell()
            return UICollectionViewCell()
            
        }
        
    }
    //Function to create a gradient image for the navigation bar, called from setUpNavBar()
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
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            //Transferring data with through the segue
            detailViewController.imageUrl = posts[indexPath.row].imageUrl!
            detailViewController.detailedDescription = posts[indexPath.row].description!
            detailViewController.playerName = posts[indexPath.row].playerName!
            detailViewController.documentId = posts[indexPath.row].documentId!
        case 1:
            let byPlayer = posts.filter({ return $0.type == "player"})
            //Transferring data with through the segue
            detailViewController.imageUrl = byPlayer[indexPath.row].imageUrl!
            detailViewController.detailedDescription = byPlayer[indexPath.row].description!
            detailViewController.playerName = byPlayer[indexPath.row].playerName!
            detailViewController.documentId = byPlayer[indexPath.row].documentId!
        case 2:
            let byTeam = posts.filter({ return $0.type == "team"})
            //Transferring data with through the segue
            detailViewController.imageUrl = byTeam[indexPath.row].imageUrl!
            detailViewController.detailedDescription = byTeam[indexPath.row].description!
            detailViewController.playerName = byTeam[indexPath.row].playerName!
            detailViewController.documentId = byTeam[indexPath.row].documentId!
        default:
            break
        }
        
        //Making the DetailedViewControllerview visible to the user
        view.window?.rootViewController = detailViewController
        view.window?.makeKeyAndVisible()
        
    }
    @IBAction func segmentControlTapped(_ sender: Any) {
        collectionView.reloadData()
    }
    
}
