//
//  Customizations.swift
//  Overtime
//
//  Created by Yue Fung Lee on 12/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
@IBDesignable
class TabBarCustomizations: UITabBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
    
    
}
        


