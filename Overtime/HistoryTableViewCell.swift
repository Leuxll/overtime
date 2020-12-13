//
//  HistoryTableViewCell.swift
//  Overtime
//
//  Created by Yue Fung Lee on 13/12/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var quizInfo: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        
        quizInfo.font = UIFont(name: "Poppins-Bold", size: 15)
        quizInfo.textColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        score.font = UIFont(name: "Poppins-Bold", size: 15)
        score.textColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        
    }

}
