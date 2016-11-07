//
//  AppDelegate.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/10/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

let swiftOrangeColor = UIColor(red: 248/255, green: 96/255.0, blue: 47/255.0, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UILabel.appearance().font = UIFont(name: "Avenir-Light", size: 17.0)
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).font = UIFont(name: "Avenir-light", size: 14.0)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = swiftOrangeColor
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir-light", size: 20.0)!]
    UITableView.appearance().separatorColor = swiftOrangeColor
    UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
    UIControl.appearance().tintColor = swiftOrangeColor
    
    let splitViewController = window!.rootViewController as! UISplitViewController
    
    // Ensures the initial CALayer detail includes the display mode button, because the row has not been selected yet
    let navigationItem = (splitViewController.viewControllers.last as! UINavigationController).topViewController!.navigationItem
    navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    navigationItem.leftItemsSupplementBackButton = true
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      splitViewController.preferredDisplayMode = .allVisible
    } else {
      splitViewController.preferredPrimaryColumnWidthFraction = 0.3
    }
    
    let size = CGSize(width: sideLength, height: sideLength)
    UIImage.saveTileOfSize(size, name: fileName)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
    
}
