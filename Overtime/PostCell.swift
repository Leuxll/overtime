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
    
    func configureCell() {

        imageView.roundCorners(cornerRadius: 40.0)
        contentView.layer.cornerRadius = 1.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
        layer.cornerRadius = 40.0
        
        nameLabel.numberOfLines = 0
        difficultyLabel.backgroundColor = UIColor(red: 109/255, green: 212/255, blue: 0, alpha: 1)
        difficultyLabel.textAlignment = .center
        difficultyLabel.textColor = .white
        difficultyLabel.layer.cornerRadius = 14.0
        difficultyLabel.layer.masksToBounds = true
        
        pointsLabel.backgroundColor = UIColor(red: 247/255, green: 181/255, blue: 0, alpha: 1)
        pointsLabel.textAlignment = .center
        pointsLabel.textColor = .white
        pointsLabel.layer.cornerRadius = 14.0
        pointsLabel.layer.masksToBounds = true
        
    }
    
}

extension UIView {
    func roundCorners(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = true
    }
}
