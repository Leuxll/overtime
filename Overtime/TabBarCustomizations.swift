//
//  Customizations.swift
//  Overtime
//
//  Created by YFL on 12/6/2020.
//  Copyright © 2020 YFL. All rights reserved.
//

import UIKit
class TabBarCustomizations: UITabBar {

    //Customization for the TabBar
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
    
    
}
        


