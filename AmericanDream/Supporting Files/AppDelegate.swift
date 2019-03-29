//
//  AppDelegate.swift
//  AmericanDream
//
//  Created by Alex on 02/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let type = Bundle.main.bundleIdentifier else {
            return
        }
        let shortcutType = shortcutItem.type
        let root = window?.rootViewController as! UITabBarController
        
        switch shortcutType {
        case type + ".ChangeRate":
            root.selectedIndex = 0
        case type + ".Translate":
            root.selectedIndex = 1
        case type + ".Weather" :
            root.selectedIndex = 2
        default:
            break
        }
        completionHandler(false)
    }

}

