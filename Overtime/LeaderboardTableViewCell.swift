//
//  LeaderboardTableViewCell.swift
//  Overtime
//
//  Created by Yue Fung Lee on 22/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        
        firstName.font = UIFont(name: "Poppins-Bold", size: 20)
        firstName.textColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        points.font = UIFont(name: "Poppins-Regular", size: 12)
        points.textColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        backgroundColor = .black
        
    }

}
