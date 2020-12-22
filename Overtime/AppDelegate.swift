//
//  AppDelegate.swift
//  Overtime
//
//  Created by Yue Fung Lee on 12/6/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initiating Firebase
        FirebaseApp.configure()
        //Configurations for the whole TabBar
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
        
        let navigationAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 25),
        ]
        
        UINavigationBar.appearance().titleTextAttributes = navigationAttributes as [NSAttributedString.Key : Any]
        UINavigationBar.appearance().alignmentRect(forFrame: CGRect(x: 37, y: 33, width: 321, height: 63))
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

