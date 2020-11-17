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
    
    //Customizations
    func configureCell() {
        
        //Configuring the 2 cell Labels within the Leaderboard cell
        Utilities.cellLabels(firstName)
        Utilities.cellLabels(points)
        
    }

}
