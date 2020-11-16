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

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var posts =  [Post]()
    private var postsCollectionRef: CollectionReference!
    private var usersCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpNavBar()
        postsCollectionRef = Firestore.firestore().collection("posts")
        listPost()
        Utilities.questions.removeAll()
        
        
    }
    
    func listPost() {
        
        postsCollectionRef.getDocuments { (snapshot, error) in
            
            guard let snap = snapshot else {return}
            for document in snap.documents {
                
                let data = document.data()
                let playerName = data["playerName"] as! String
                let difficulty = data["difficulty"] as! String
                let imageUrl = data["imageUrl"] as! String
                let description = data["description"] as! String
                let points = data["points"] as! String
                let documentId = document.documentID
                
                self.posts.append(Post(imageUrl: imageUrl, playerName: playerName, points: points, difficulty: difficulty, description: description, documentId: documentId))
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PostCell {
            
            cell.imageView.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "Default_Image_Thumbnail.png"))
            cell.difficultyLabel.text = posts[indexPath.row].difficulty
            cell.nameLabel.text = posts[indexPath.row].playerName
            cell.pointsLabel.text = posts[indexPath.row].points
            cell.configureCell()
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
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
            
            let nameOfScreen = UILabel()
            nameOfScreen.textColor = .white
            nameOfScreen.text = "Welcome"
            nameOfScreen.font = UIFont(name: "Poppins-Bold", size: 27)
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: nameOfScreen)
            
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailedViewController) as! DetailedViewController
        
        detailViewController.imageUrl = posts[indexPath.row].imageUrl!
        detailViewController.detailedDescription = posts[indexPath.row].description!
        detailViewController.playerName = posts[indexPath.row].playerName!
        detailViewController.documentId = posts[indexPath.row].documentId!
        
        view.window?.rootViewController = detailViewController
        view.window?.makeKeyAndVisible()
        
    }

}
