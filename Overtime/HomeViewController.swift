//
//  HomeViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 13/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
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
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            gradient.frame = bounds
            gradient.colors = [UIColor(red: 255/255, green: 121/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1).cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)

            if let image = getImageFrom(gradientLayer: gradient) {
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
        }
        
    }
    
    

}
