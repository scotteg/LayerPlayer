/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

let swiftOrangeColor = UIColor(red: 248/255, green: 96/255.0, blue: 47/255.0, alpha: 1.0)
let lighterSwiftOrangeColor = UIColor(red: 255/255, green: 160/255.0, blue: 70/255.0, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UILabel.appearance().font = UIFont(name: "Avenir-Light", size: 17.0)
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).font = UIFont(name: "Avenir-light", size: 14.0)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = swiftOrangeColor
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Avenir-light", size: 20.0)!]
    UITableView.appearance().separatorColor = swiftOrangeColor
    UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
    UISwitch.appearance().tintColor = swiftOrangeColor
    UISlider.appearance().tintColor = swiftOrangeColor
    UISegmentedControl.appearance().tintColor = swiftOrangeColor
    
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
