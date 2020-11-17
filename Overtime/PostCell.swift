//
//  PostCell.swift
//  Overtime
//
//  Created by Yue Fung Lee on 15/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit


class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    //Customizations
    func configureCell() {

        imageView.roundCorners(cornerRadius: 40.0)
        contentView.layer.cornerRadius = 1.0
        contentView.layer.masksToBounds = false
        layer.masksToBounds = true
        layer.cornerRadius = 40.0
        layer.borderColor = UIColor.init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).cgColor
        layer.borderWidth = 5
        
        nameLabel.numberOfLines = 0
        
        Utilities.difficultyLabel(difficultyLabel)
        Utilities.pointsLabel(pointsLabel)
        
    }
    
}

//Customizting the Cells with rounded corders
extension UIView {
    func roundCorners(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = true
    }
}
